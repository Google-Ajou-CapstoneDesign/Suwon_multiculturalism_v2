"""DB/Organizations/*.csv(5개 파일, 32개 기관)를 읽어 주소를 위경도로 지오코딩하고,
Firestore 시딩·백엔드 폴백에 바로 쓸 수 있는 하나의 JSON으로 합친다.

무료 지오코딩(Nominatim/OpenStreetMap)을 1차로 시도하고, 결과가 없거나 신뢰도가
낮으면(건물명 위주 주소 등) needs_review=true로 표시만 해서 사람이 수동으로
보정할 수 있게 한다 — 정확도를 100% 자동화로 보장하지 않는다.

Nominatim 사용 정책(1req/sec, 식별 가능한 User-Agent 필수)을 지킨다.

실행:
    cd backend
    python scripts/geocode_organizations.py

출력:
    app/data/organizations.json  (지오코딩 결과 포함, 검수 후 seed_organizations.py가 읽음)
    scripts/_geocode_review.csv  (needs_review=true 행만 모아 사람이 보기 쉽게 정리 — 없으면 전부 성공)
"""

import csv
import json
import re
import sys
import time
import urllib.parse
import urllib.request
from pathlib import Path

# Windows 콘솔 기본 코드페이지(cp949)는 이모지·일부 유니코드를 못 씁니다.
if hasattr(sys.stdout, "reconfigure"):
    sys.stdout.reconfigure(encoding="utf-8")
    sys.stderr.reconfigure(encoding="utf-8")

_REPO_ROOT = Path(__file__).resolve().parent.parent.parent
_CSV_DIR = _REPO_ROOT / "DB" / "Organizations"
_OUT_JSON = Path(__file__).resolve().parent.parent / "app" / "data" / "organizations.json"
_REVIEW_CSV = Path(__file__).resolve().parent / "_geocode_review.csv"

_USER_AGENT = "LocalBridgeCapstone/1.0 (Ajou Univ. capstone project; contact: teameqlab@gmail.com)"
_NOMINATIM_URL = "https://nominatim.openstreetmap.org/search"


def _split_lines(value: str) -> list[str]:
    return [line.strip() for line in value.replace("\r\n", "\n").split("\n") if line.strip()]


_PROVINCE_PREFIX = re.compile(
    r"^\S*?(?:특별자치도|특별자치시|광역시|특별시|도)\s+"
)


def _geocode_candidates(address: str) -> list[str]:
    """지오코딩 재시도용 쿼리 후보를 정확도가 높을 것으로 예상되는 순서로 만든다.

    실제로 겪은 문제 두 가지를 순서대로 처리한다:
    1. "경기도 수원시 팔달구 효원로 241"처럼 맨 앞 광역단위(도/특별시 등)를 붙이면
       Nominatim이 오히려 매칭을 못 하는 경우가 많다 — 뺀 버전도 같이 시도한다.
    2. "혁신2로 26(율곡동, ...)"처럼 도로명이 안 잡히는 주소는 괄호 안에 있는
       동/읍/면 단위로 대체하면 매칭되는 경우가 있다 — 최후 후보로 넣는다.
    """
    first = _split_lines(address)[0] if address else ""
    if not first:
        return []

    candidates = [first]

    no_paren = re.sub(r"\(.*?\)", "", first).strip()
    if no_paren and no_paren not in candidates:
        candidates.append(no_paren)

    no_province = _PROVINCE_PREFIX.sub("", first).strip()
    if no_province and no_province not in candidates:
        candidates.append(no_province)

    no_province_no_paren = _PROVINCE_PREFIX.sub("", no_paren).strip()
    if no_province_no_paren and no_province_no_paren not in candidates:
        candidates.append(no_province_no_paren)

    # "추동로 140, 2층"처럼 쉼표 뒤 층/호 같은 상세정보가 오히려 매칭을 깨는
    # 경우가 있어, 마지막 쉼표 이전까지만 쓰는 후보도 추가한다.
    if "," in no_province_no_paren:
        before_comma = no_province_no_paren.rsplit(",", 1)[0].strip()
        if before_comma and before_comma not in candidates:
            candidates.append(before_comma)

    # 동/읍/면 단위 보조 후보 — 괄호 안(주소 원문 전체)에서도 찾는다.
    city_match = re.search(r"(\S+시)\b", address)
    dong_match = re.search(r"(\S+(?:동|읍|면))\b", address)
    if city_match and dong_match:
        fallback = f"{city_match.group(1)} {dong_match.group(1)}"
        if fallback not in candidates:
            candidates.append(fallback)

    return candidates


def _geocode(query: str) -> tuple[float, float] | None:
    if not query:
        return None
    params = urllib.parse.urlencode({"q": query, "format": "json", "limit": 1, "countrycodes": "kr"})
    req = urllib.request.Request(
        f"{_NOMINATIM_URL}?{params}", headers={"User-Agent": _USER_AGENT}
    )
    try:
        with urllib.request.urlopen(req, timeout=15) as resp:
            data = json.loads(resp.read().decode("utf-8"))
    except Exception as exc:  # noqa: BLE001 - 지오코딩 실패는 needs_review로 남기고 계속 진행
        print(f"  ! 지오코딩 요청 실패({query}): {exc}", file=sys.stderr)
        return None
    if not data:
        return None
    return float(data[0]["lat"]), float(data[0]["lon"])


def _split_website_email(raw: str) -> tuple[str | None, str | None]:
    website = None
    email = None
    for line in _split_lines(raw):
        if line == "-":
            continue
        if "@" in line and email is None:
            email = line
        elif website is None:
            website = line
    return website, email


def main() -> None:
    csv_files = sorted(_CSV_DIR.glob("*.csv"))
    if not csv_files:
        print(f"CSV를 찾지 못했습니다: {_CSV_DIR}", file=sys.stderr)
        raise SystemExit(1)

    orgs: list[dict] = []
    review_rows: list[dict] = []

    for csv_path in csv_files:
        with csv_path.open(encoding="utf-8-sig", newline="") as fh:
            reader = csv.DictReader(fh)
            for row in reader:
                name = row["기관"].strip()
                address = row["주소"].strip()
                print(f"지오코딩 중: {name} ({address[:30]}...)")

                coords = None
                query = ""
                for i, candidate in enumerate(_geocode_candidates(address)):
                    if i > 0:
                        time.sleep(1)  # Nominatim 사용 정책: 최대 1req/sec
                    coords = _geocode(candidate)
                    query = candidate
                    if coords:
                        break
                needs_review = coords is None

                website, email = _split_website_email(row["홈페이지 / 이메일"])
                org = {
                    "name": name,
                    "description": row["설명(무슨 기관인가)"].strip(),
                    "phone_number": row["전화번호"].strip() or None,
                    "address": address,
                    "website_url": website,
                    "email": email,
                    "business_hours": row["이용기간(업무시간)"].strip() or None,
                    "recommended_for": row["추천 대상"].strip(),
                    "latitude": coords[0] if coords else None,
                    "longitude": coords[1] if coords else None,
                    "source_file": csv_path.name,
                    "needs_review": needs_review,
                }
                orgs.append(org)
                if needs_review:
                    review_rows.append({"name": name, "address": address, "geocode_query": query})

                time.sleep(1)  # Nominatim 사용 정책: 최대 1req/sec

    _OUT_JSON.parent.mkdir(parents=True, exist_ok=True)
    _OUT_JSON.write_text(
        json.dumps(orgs, ensure_ascii=False, indent=2), encoding="utf-8"
    )
    print(f"\n{len(orgs)}개 기관을 {_OUT_JSON}에 저장했습니다.")

    if review_rows:
        with _REVIEW_CSV.open("w", encoding="utf-8-sig", newline="") as fh:
            writer = csv.DictWriter(fh, fieldnames=["name", "address", "geocode_query"])
            writer.writeheader()
            writer.writerows(review_rows)
        print(
            f"⚠ {len(review_rows)}개 기관은 자동 지오코딩에 실패했습니다 — "
            f"{_REVIEW_CSV}를 확인하고 {_OUT_JSON}의 해당 항목 latitude/longitude를 직접 채워주세요."
        )
    else:
        print("모든 기관의 지오코딩에 성공했습니다 — 수동 보정이 필요 없습니다.")


if __name__ == "__main__":
    main()

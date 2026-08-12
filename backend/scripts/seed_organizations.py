"""`organizations` 컬렉션 시딩.

docs/firestore_스키마.md §3에서 설계한 스키마로, scripts/geocode_organizations.py가
DB/Organizations/*.csv(5개 파일, 32개 기관)를 지오코딩해 만든
app/data/organizations.json을 그대로 Firestore에 올린다.

실행 전:
1. backend/.env에 GOOGLE_APPLICATION_CREDENTIALS 또는 FIREBASE_CREDENTIALS_JSON을 설정.
2. app/data/organizations.json이 최신 상태인지 확인(없으면 먼저
   `python scripts/geocode_organizations.py`를 실행).

실행:
    cd backend
    python scripts/seed_organizations.py

기존 organizations 컬렉션 문서를 전부 지우고 다시 채운다(멱등적 재실행) —
그렇지 않으면 재실행할 때마다 중복 문서가 쌓인다.
"""

import json
import sys
from datetime import datetime, timezone
from pathlib import Path

if hasattr(sys.stdout, "reconfigure"):
    sys.stdout.reconfigure(encoding="utf-8")

sys.path.insert(0, str(Path(__file__).resolve().parent.parent))

from app.core.firebase import get_firebase_app  # noqa: E402

_ORGS_JSON = Path(__file__).resolve().parent.parent / "app" / "data" / "organizations.json"
_COLLECTION = "organizations"


def main() -> None:
    app = get_firebase_app()
    if app is None:
        print(
            "Firebase 자격증명이 설정되지 않았습니다. "
            "backend/.env의 GOOGLE_APPLICATION_CREDENTIALS 또는 "
            "FIREBASE_CREDENTIALS_JSON을 먼저 채워주세요."
        )
        raise SystemExit(1)

    if not _ORGS_JSON.exists():
        print(
            f"{_ORGS_JSON}이 없습니다. 먼저 "
            "`python scripts/geocode_organizations.py`를 실행해 생성해주세요."
        )
        raise SystemExit(1)

    from firebase_admin import firestore

    db = firestore.client(app)
    orgs = json.loads(_ORGS_JSON.read_text(encoding="utf-8"))

    existing = list(db.collection(_COLLECTION).stream())
    if existing:
        delete_batch = db.batch()
        for doc in existing:
            delete_batch.delete(doc.reference)
        delete_batch.commit()
        print(f"기존 문서 {len(existing)}개를 지웠습니다.")

    now = datetime.now(timezone.utc)
    batch = db.batch()
    needs_review_count = 0
    for org in orgs:
        doc_ref = db.collection(_COLLECTION).document()
        if org.get("needs_review"):
            needs_review_count += 1
        batch.set(
            doc_ref,
            {
                "org_id": doc_ref.id,
                "name": org["name"],
                "description": org.get("description") or "",
                "phone_number": org.get("phone_number"),
                "address": org.get("address") or "",
                "website_url": org.get("website_url"),
                "email": org.get("email"),
                "business_hours": org.get("business_hours"),
                "recommended_for": org.get("recommended_for") or "",
                "latitude": org.get("latitude"),
                "longitude": org.get("longitude"),
                "source_file": org.get("source_file"),
                "is_active": True,
                "created_at": now,
                "updated_at": now,
            },
        )
    batch.commit()
    print(f"{len(orgs)}개 기관을 '{_COLLECTION}' 컬렉션에 등록했습니다.")
    if needs_review_count:
        print(
            f"참고: {needs_review_count}개는 위경도가 없습니다(오프라인 주소가 "
            "없는 콜센터·온라인 포털 등) — 거리 정렬 시 자동으로 뒤로 밀려날 뿐, "
            "정상적인 상태입니다."
        )


if __name__ == "__main__":
    main()

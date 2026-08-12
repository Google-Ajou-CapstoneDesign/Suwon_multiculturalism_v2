"""`organizations` 컬렉션 초기 시딩.

docs/firestore_스키마.md §3에서 설계한 스키마로, 기존 app/data/orgs.json(name/lat/lng/
categories만 존재)의 검증된 값만 그대로 옮긴다. description/phone_number/address/
business_hours/website_url/email/recommended_for처럼 orgs.json에 없는 필드는 실제
기관에 확인한 값으로 채워야 하므로 빈 문자열/빈 배열로만 남겨둔다 — 실존 정부·공공
기관의 연락처를 여기서 지어내지 않는다.

실행 전:
1. backend/.env에 GOOGLE_APPLICATION_CREDENTIALS 또는 FIREBASE_CREDENTIALS_JSON을 설정.
2. Firestore가 이미 활성화된 Firebase 프로젝트여야 한다.

실행:
    cd backend
    python scripts/seed_organizations.py
"""

import json
import sys
from datetime import datetime, timezone
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parent.parent))

from app.core.firebase import get_firebase_app  # noqa: E402

_ORGS_JSON = Path(__file__).resolve().parent.parent / "app" / "data" / "orgs.json"
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

    from firebase_admin import firestore

    db = firestore.client(app)
    orgs = json.loads(_ORGS_JSON.read_text(encoding="utf-8"))

    now = datetime.now(timezone.utc)
    batch = db.batch()
    for org in orgs:
        doc_ref = db.collection(_COLLECTION).document()
        batch.set(
            doc_ref,
            {
                "org_id": doc_ref.id,
                "name": org["name"],
                "description": "",  # TODO: 실제 기관 설명으로 채우기
                "phone_number": None,  # TODO: 실제 대표번호로 채우기
                "address": "",  # TODO: 실제 주소로 채우기
                "website_url": None,
                "email": None,
                "business_hours": None,  # TODO: 예) "평일 09:00–18:00"
                "recommended_for": [],  # TODO: 예) ["E-9", "H-2"] 또는 상황 키워드
                "categories": org["categories"],
                "latitude": org["lat"],
                "longitude": org["lng"],
                "languages_supported": [],
                "is_active": True,
                "created_at": now,
                "updated_at": now,
            },
        )
    batch.commit()
    print(f"{len(orgs)}개 기관을 '{_COLLECTION}' 컬렉션에 등록했습니다.")
    print("⚠ description/phone_number/address/business_hours 등은 빈 값이니 콘솔에서 실제 값으로 채워주세요.")


if __name__ == "__main__":
    main()

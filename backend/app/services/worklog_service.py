"""Firestore worklogs/{worklogId} 근무기록 저장·조회.

user_service.py/history_service.py와 동일한 폴백 원칙: Firebase 자격증명이
없으면(로컬 개발, CI) 조용히 None/빈 값으로 동작한다.

문서 ID는 auto-id 대신 `{uid}_{date}`로 결정론적으로 만든다 — 같은 날짜를
여러 번 PUT해도 문서가 중복 생성되지 않고 그대로 갱신된다. DB/firestore.rules의
`worklogs/{worklogId}` 규칙은 문서 안 user_id 필드만 검사하므로 이 ID 형식과
무관하게 그대로 통과한다.
"""

import logging
from datetime import date, datetime, time, timezone
from typing import List, Optional

from ..core.firebase import get_firebase_app
from ..core.logging_utils import log_exception_summary
from ..schemas.worklog import WorklogDay, WorklogDayUpsert

logger = logging.getLogger(__name__)

_COLLECTION = "worklogs"

# 근로기준법상 1일 법정근로 8시간 초과분을 연장근로로 본다 — 이 판정은
# 사실(근무 시각) 그대로에서 나오는 산수이지 LLM/서버가 임의로 내리는
# 법적 결론이 아니다(wage_rules.classify와 같은 원칙).
_OVERTIME_THRESHOLD_MINUTES = 8 * 60


def _client():
    app = get_firebase_app()
    if app is None:
        return None
    from firebase_admin import firestore  # 앱 미초기화 시 임포트 비용을 피하기 위한 지연 임포트

    return firestore.client(app)


def doc_id(uid: str, day: date) -> str:
    return f"{uid}_{day.isoformat()}"


def _parse_time(value: Optional[str]) -> Optional[time]:
    if not value:
        return None
    hour, minute = value.split(":")
    return time(int(hour), int(minute))


def _worked_minutes(clock_in: Optional[str], clock_out: Optional[str], break_minutes: int) -> int:
    start = _parse_time(clock_in)
    end = _parse_time(clock_out)
    if start is None or end is None:
        return 0
    minutes = (end.hour * 60 + end.minute) - (start.hour * 60 + start.minute) - break_minutes
    return max(minutes, 0)


def _to_model(data: dict) -> WorklogDay:
    raw_date = data["date"]
    day = raw_date.date() if hasattr(raw_date, "date") else raw_date
    return WorklogDay(
        worklog_id=data["worklog_id"],
        user_id=data["user_id"],
        date=day,
        clock_in=data.get("clock_in"),
        clock_out=data.get("clock_out"),
        break_minutes=data.get("break_minutes", 0),
        memo=data.get("memo", ""),
        is_overtime=data.get("is_overtime", False),
        is_risk=data.get("is_risk", False),
        gps_verified=data.get("gps_verified", False),
        evidence_file_ids=data.get("evidence_file_ids", []),
    )


def upsert_day(uid: str, day: date, patch: WorklogDayUpsert) -> Optional[WorklogDay]:
    db = _client()
    if db is None:
        return None
    try:
        record_id = doc_id(uid, day)
        doc_ref = db.collection(_COLLECTION).document(record_id)
        worked_minutes = _worked_minutes(patch.clock_in, patch.clock_out, patch.break_minutes)
        now = datetime.now(timezone.utc)
        data = {
            "worklog_id": record_id,
            "user_id": uid,
            "date": datetime.combine(day, time.min, tzinfo=timezone.utc),
            "clock_in": patch.clock_in,
            "clock_out": patch.clock_out,
            "break_minutes": patch.break_minutes,
            "memo": patch.memo,
            "gps_verified": patch.gps_verified,
            "is_overtime": worked_minutes > _OVERTIME_THRESHOLD_MINUTES,
            "updated_at": now,
        }
        if not doc_ref.get().exists:
            data["created_at"] = now
            data["is_risk"] = False
            data["evidence_file_ids"] = []
        doc_ref.set(data, merge=True)
        return get_day(uid, day)
    except Exception as exc:
        log_exception_summary(logger, "근무기록 저장 실패", exc)
        logger.exception("근무기록 저장 실패 전체 트레이스백")
        return None


def get_day(uid: str, day: date) -> Optional[WorklogDay]:
    db = _client()
    if db is None:
        return None
    try:
        doc = db.collection(_COLLECTION).document(doc_id(uid, day)).get()
        if not doc.exists:
            return None
        return _to_model(doc.to_dict())
    except Exception as exc:
        log_exception_summary(logger, "근무기록 조회 실패", exc)
        logger.exception("근무기록 조회 실패 전체 트레이스백")
        return None


def list_month(uid: str, year: int, month: int) -> List[WorklogDay]:
    db = _client()
    if db is None:
        return []
    try:
        start = datetime(year, month, 1, tzinfo=timezone.utc)
        end = (
            datetime(year + 1, 1, 1, tzinfo=timezone.utc)
            if month == 12
            else datetime(year, month + 1, 1, tzinfo=timezone.utc)
        )
        docs = (
            db.collection(_COLLECTION)
            .where("user_id", "==", uid)
            .where("date", ">=", start)
            .where("date", "<", end)
            .order_by("date")
            .stream()
        )
        return [_to_model(doc.to_dict()) for doc in docs]
    except Exception as exc:
        log_exception_summary(logger, "근무기록 월별 조회 실패", exc)
        logger.exception("근무기록 월별 조회 전체 트레이스백")
        return []


def append_evidence_file(uid: str, day: date, file_id: str) -> None:
    """업로드된 증빙파일을 해당 근무일 문서의 evidence_file_ids 배열에 연결한다.
    근무기록 자체가 아직 없어도(하루도 기록 안 한 날에 사진만 먼저 올린 경우)
    문서를 새로 만들며 이 필드만 채운다 — 나머지 필드는 다음 upsert_day 호출 때
    채워진다."""

    db = _client()
    if db is None:
        return
    try:
        from firebase_admin import firestore

        record_id = doc_id(uid, day)
        db.collection(_COLLECTION).document(record_id).set(
            {
                "worklog_id": record_id,
                "user_id": uid,
                "evidence_file_ids": firestore.ArrayUnion([file_id]),
            },
            merge=True,
        )
    except Exception as exc:
        log_exception_summary(logger, "근무기록에 증빙파일 연결 실패", exc)
        logger.exception("근무기록에 증빙파일 연결 실패 전체 트레이스백")

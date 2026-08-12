"""한국 표준시(KST, UTC+9) 기준 날짜·요일 유틸.

Cloud Run 등 서버는 보통 UTC로 동작한다 — date.today()/datetime.now()를 그대로
쓰면 한국 시간 기준 자정~오전 9시 사이에 "오늘"이 하루 밀려서 계산된다.
임금체불 지급기한 판정(wage_rules.classify)처럼 "오늘 날짜"가 결과에 직접
영향을 주는 계산과, 에이전트가 사용자에게 "오늘"/"내일"을 언급할 때 모두 이
모듈을 통해 KST 기준으로 맞춘다.
"""

from datetime import date, datetime, timedelta, timezone

KST = timezone(timedelta(hours=9))

_WEEKDAY_KO = ["월", "화", "수", "목", "금", "토", "일"]


def now_kst() -> datetime:
    return datetime.now(KST)


def today_kst() -> date:
    return now_kst().date()


def weekday_kst_ko(d: date) -> str:
    return _WEEKDAY_KO[d.weekday()]

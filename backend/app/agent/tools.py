"""에이전트가 호출하는 Tools.

각 함수의 docstring·타입 힌트가 그대로 Gemini function calling 스키마(이름·
설명·파라미터)로 변환된다 — 문서화가 곧 스펙이므로 설명을 생략하지 않는다.

uid 같은 요청 컨텍스트는 LLM이 파라미터로 채우게 두지 않는다(다른 사용자의
이력을 조회하도록 유도하는 프롬프트 인젝션을 막기 위함) — build_tools()가
호출 시점의 컨텍스트를 클로저로 미리 묶어 도구를 만들어 넘긴다.
"""

import logging
from datetime import date
from typing import Callable, List, Optional

from ..schemas.wage import WageFacts
from ..services import document_search_service, history_service, org_service, wage_rules

logger = logging.getLogger(__name__)


def build_tools(*, uid: Optional[str]) -> List[Callable]:
    def get_user_history(limit: int = 5) -> dict:
        """이 사용자의 최근 상담 이력을 조회합니다.

        사용자가 "저번에 물어본 거", "이전 상담" 등 과거 맥락을 언급하거나,
        이전에 무엇을 안내받았는지 참고하면 더 정확히 답할 수 있을 때 호출하세요.

        Args:
            limit: 가져올 최근 이력 개수(기본 5개, 최대 20개).

        Returns:
            최근 상담 이력 목록(turns). 로그인하지 않았거나 이력이 없으면
            빈 목록을 반환합니다.
        """
        if not uid:
            return {"turns": [], "note": "로그인하지 않은 사용자라 이력이 없습니다."}
        return {"turns": history_service.get_recent_history(uid, limit=min(limit, 20))}

    def calculate_wage(
        work_start_date: str,
        last_work_date: str,
        unpaid_amount: int,
        agreed_monthly_salary: int,
        has_contract: bool,
        workplace_name: str,
    ) -> dict:
        """근로기준법 제36조(퇴직 후 14일 이내 금품 청산) 기준으로 임금체불 여부와
        지급기한 초과 일수를 계산합니다.

        임금·체불과 관련된 날짜·금액 수치를 사용자에게 안내할 때는 절대 직접
        암산하지 말고 반드시 이 도구를 호출해 계산된 값만 사용하세요.

        Args:
            work_start_date: 근무 시작일 (YYYY-MM-DD).
            last_work_date: 마지막 근무일 또는 퇴직일 (YYYY-MM-DD).
            unpaid_amount: 아직 받지 못한 금액(원).
            agreed_monthly_salary: 약정 월급(원).
            has_contract: 근로계약서 작성 여부.
            workplace_name: 사업장 이름.

        Returns:
            지급기한(payment_due_date), 초과 일수(days_overdue), 체불 여부
            (is_overdue), 안내 문구(guidance). 입력값이 잘못되면 error 키를 담아
            반환합니다.
        """
        try:
            facts = WageFacts(
                work_start_date=date.fromisoformat(work_start_date),
                last_work_date=date.fromisoformat(last_work_date),
                unpaid_amount=unpaid_amount,
                agreed_monthly_salary=agreed_monthly_salary,
                has_contract=has_contract,
                workplace_name=workplace_name,
            )
        except ValueError as exc:
            return {"error": f"입력값을 확인해 주세요: {exc}"}

        result = wage_rules.classify(facts)
        return result.model_dump(mode="json")

    def search_support_orgs(
        category: Optional[str] = None,
        lat: Optional[float] = None,
        lng: Optional[float] = None,
    ) -> dict:
        """GCP(Firestore/사전 등록 데이터)에 보관된 수원시 노동 상담·지원 기관
        목록을 조회합니다. 가까운 기관이나 문의처를 안내할 때 호출하세요.

        Args:
            category: 기관 분류(예: "wage", "accident"). 모르면 비워두세요.
            lat: 사용자 위도. 모르면 비워두세요.
            lng: 사용자 경도. 모르면 비워두세요.

        Returns:
            이름(name)과 거리(distance_km)를 포함한 기관 목록(orgs).
        """
        try:
            orgs = org_service.list_orgs(lat=lat, lng=lng, category=category)
        except Exception as exc:  # noqa: BLE001 - 도구 실패를 모델에게 알려 회복시킨다.
            logger.exception("기관 조회 도구 실패")
            return {"error": str(exc)}
        return {"orgs": [org.model_dump(mode="json") for org in orgs]}

    def search_reference_documents(query: str) -> dict:
        """GCP 데이터스토어(Vertex AI Search)에 미리 임베딩·색인해 둔 근로기준법
        조문·정부 안내 문서에서 질문과 관련된 문서 조각을 검색합니다.

        법 조항 번호나 정확한 제도 내용처럼 원문 근거가 필요한 질문에는 이 도구로
        찾은 조각만 인용하세요 — 조문 내용을 직접 지어내지 마세요. 데이터스토어가
        아직 설정되지 않았거나 관련 문서가 없으면 빈 목록이 돌아오니, 그럴 땐 이미
        알고 있는 일반적인 안내로 답하되 원문을 인용하고 있다고 말하지 마세요.

        Args:
            query: 검색할 질문 또는 키워드.

        Returns:
            관련 문서 조각 목록(documents) — title, snippet(본문 발췌), link.
        """
        try:
            results = document_search_service.search_documents(query)
        except Exception as exc:  # noqa: BLE001 - 도구 실패를 모델에게 알려 회복시킨다.
            logger.exception("문서 검색 도구 실패")
            return {"error": str(exc)}
        return {
            "documents": [
                {"title": r.title, "snippet": r.snippet, "link": r.link} for r in results
            ]
        }

    return [
        get_user_history,
        calculate_wage,
        search_support_orgs,
        search_reference_documents,
    ]

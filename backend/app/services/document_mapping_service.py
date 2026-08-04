"""표준 서식 자동 채움. 공인노무사법 제27조 리스크 방어를 위해
사실형(auto) / 서술형(verbatim) / 판단형(blocked) 필드를 서버 로직으로 강제한다.
어떤 필드에도 새로운 법적 주장 문장을 생성하지 않는다(단순 치환·원문 그대로 출력뿐).
"""

from ..schemas.document_mapping import MappingRow, WageMappingRequest, WageMappingResponse

_BLOCKED_NOTICE = "복잡 산정 항목은 공란으로 남겨요. 상담 시 노무사·근로감독관과 함께 작성하세요."
_DISCLAIMER = "본 문서는 입력하신 사실관계를 양식에 옮긴 것이며 법적 주장·판단을 포함하지 않습니다."


def build_wage_mapping(request: WageMappingRequest) -> WageMappingResponse:
    facts = request.facts
    period = f"{facts.work_start_date.isoformat()} ~ {facts.last_work_date.isoformat()}"

    rows = [
        MappingRow(label="성명", value=request.claimant.name, status="auto"),
        MappingRow(label="사업장명", value=facts.workplace_name, status="auto"),
        MappingRow(label="근무기간", value=period, status="auto"),
        MappingRow(label="미지급액", value=f"{facts.unpaid_amount:,}원", status="auto"),
        MappingRow(label="진정 취지 및 경위", value=request.narrative, status="verbatim"),
        MappingRow(label="통상임금·시간외수당 등", status="blocked", notice=_BLOCKED_NOTICE),
    ]
    return WageMappingResponse(rows=rows, disclaimer=_DISCLAIMER)

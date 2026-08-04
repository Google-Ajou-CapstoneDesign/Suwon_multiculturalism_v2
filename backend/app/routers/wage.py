from fastapi import APIRouter, Depends

from ..core.auth import CurrentUser, get_current_user
from ..schemas.document_mapping import WageMappingRequest, WageMappingResponse
from ..schemas.wage import WageClassifyResponse, WageFacts
from ..services import document_mapping_service, wage_rules

router = APIRouter(prefix="/api/wage", tags=["wage"])


@router.post("/classify", response_model=WageClassifyResponse)
def classify_wage(facts: WageFacts, _user: CurrentUser = Depends(get_current_user)) -> WageClassifyResponse:
    return wage_rules.classify(facts)


@router.post("/document-mapping", response_model=WageMappingResponse)
def map_wage_document(
    request: WageMappingRequest, _user: CurrentUser = Depends(get_current_user)
) -> WageMappingResponse:
    return document_mapping_service.build_wage_mapping(request)

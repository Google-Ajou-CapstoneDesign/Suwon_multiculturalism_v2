# 수원시 이주민을 위한 노동 정보 통합 플랫폼

## 작업 규칙
- 응답은 한국어로 작성
- 모든 기능 구현에 대해서 번역기능을 고려할 것


## 기술 스택
- Frontend
    - flutter로 작성
- backend
    - GCP에서 에이전트 빌드 후 사용
    - Cloud run에서 API 빌드 후 사용
- DB
    - firebase 사용

## 인지할 사항
- 현재 디렉토리의 커밋이 그대로 Cloud Run에 올라가는게 아닌, Local_Bridge_Backend라는 다른 디렉토리에 복사하고 거기서 커밋을 진행한다. 따라서 Cloud Run의 리비전과 현재 디렉토리 커밋 리비전이 다를 수 있다.
- Frontend도 동일하게 별도의 레포지토리에 복사하여 빌드, 배포한다.
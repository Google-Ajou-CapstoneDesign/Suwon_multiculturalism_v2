import os

# 테스트에서는 Firebase 자격증명 없이 인증 우회 모드로 동작한다.
# 앱 모듈이 import되기 전에 설정되어야 하므로 conftest 최상단에 둔다.
os.environ.setdefault("AUTH_DEV_BYPASS", "true")

"""예외 로깅 유틸.

Cloud Run은 여러 줄짜리 파이썬 트레이스백을 하나의 로그 항목으로 모아주지만,
Logs Explorer 미리보기나 터미널로 복사하는 과정에서 글자 수 제한에 걸려
중간에서 잘리는 일이 잦다 — ADK 에이전트 루프처럼 내부 프레임이 30개가 넘는
경우 특히 그렇다. 그러면 정작 제일 필요한 마지막 줄(예외 타입·메시지)이
잘려서 안 보인다. 그래서 전체 트레이스백(logger.exception)과 별개로, 예외
타입·메시지만 담은 짧은 한 줄 요약을 항상 같이 남긴다 — 이 요약 줄은 짧아서
잘릴 일이 없고, 원인 파악에 필요한 정보만 바로 보여준다.
"""

import logging


def log_exception_summary(logger: logging.Logger, message: str, exc: BaseException) -> None:
    logger.error("%s — 원인: %s: %s", message, type(exc).__name__, exc)

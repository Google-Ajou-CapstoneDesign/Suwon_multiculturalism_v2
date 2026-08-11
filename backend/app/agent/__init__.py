"""ADK(Agent Development Kit) 기반 상담 에이전트 파이프라인.

에이전트구상.png의 흐름을 구현한다 — 주제 판별(chat_service)을 통과한 요청만
여기로 들어와 Tools(사용자 이력 조회·임금 계산·기관 조회)를 갖춘 Gemini 에이전트
루프를 돈다.
"""

FROM python:3.11-slim

WORKDIR /app

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY . .

RUN useradd -m -u 1000 appuser
USER appuser

# Cloud Run은 PORT 환경변수(기본 8080)로 리스닝 포트를 주입한다.
ENV PORT=8080
EXPOSE 8080

# 쉘 폼(CMD가 배열이 아님)이어야 ${PORT} 확장이 된다.
CMD exec uvicorn app.main:app --host 0.0.0.0 --port ${PORT}

FROM ubuntu:22.04

# 필수 패키지 설치
# - ca-certificates: HTTPS 인증서 검증
# - curl: sshx 설치 스크립트 다운로드
# - python3: 간단 HTTP 서버 실행
RUN apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
       ca-certificates \
       curl \
       python3 \
    && rm -rf /var/lib/apt/lists/*

# sshx 설치(실패 시 빌드 중단 방지하려면 || true 추가 가능)
RUN curl -sSf https://sshx.io/get | sh

WORKDIR /app
RUN echo "SSHX is running..." > index.html

# 문서화용(플랫폼에 따라 필수는 아님)
EXPOSE 8080

# HTTP 8080 + sshx 동시 실행
CMD python3 -m http.server 8080 & exec sshx

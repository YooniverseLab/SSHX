FROM ubuntu:22.04

# 필수 패키지 설치
# - systemd: 테스트용(설치만 권장)
# - ca-certificates: HTTPS 인증서
# - curl: 다운로드 유틸
# - python3: 간단 HTTP 서버
RUN apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
       systemd \
       ca-certificates \
       curl \
       python3 \
    && rm -rf /var/lib/apt/lists/*

# sshx 설치
RUN curl -sSf https://sshx.io/get | sh

WORKDIR /app
RUN echo "SSHX is running..." > index.html

EXPOSE 8080

CMD python3 -m http.server 8080 & sshx

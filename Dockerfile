FROM ubuntu:22.04

# 필수 패키지 설치
# - systemd: 컨테이너 내부 서비스 테스트용(설치만, 구동은 비권장)
# - ca-certificates: HTTPS 인증서 검증
# - curl: sshx 설치 스크립트 다운로드
# - python3: 간단 HTTP 서버 실행
RUN apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
       systemd \               # 필요 시 설치(구동 별도 설정 필요)
       ca-certificates \       # HTTPS 인증서
       curl \                  # 다운로드 유틸
       python3 \               # HTTP 서버
    && rm -rf /var/lib/apt/lists/*

# sshx 설치 스크립트 실행
# -sS: 진행 표시 최소화 + 오류 메시지 표시
# -f: HTTP 오류 시 실패 처리
RUN curl -sSf https://sshx.io/get | sh

# 작업 디렉터리 및 확인용 페이지
WORKDIR /app
RUN echo "SSHX is running..." > index.html

# 서비스 포트
EXPOSE 8080

# 간단 HTTP 서버 실행 후 sshx 실행
CMD python3 -m http.server 8080 & sshx

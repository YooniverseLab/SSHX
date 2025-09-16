# 사용할 기본 이미지 지정
FROM ubuntu:22.04

# 필요한 패키지 설치
# curl: sshx 설치 스크립트를 다운로드하는 데 사용
# ca-certificates: curl이 HTTPS 연결을 신뢰하는 데 필요
# python3: Render 서비스 유지를 위한 더미 웹 서버 실행에 필요
# -y: 모든 프롬프트에 'yes'로 응답하여 설치를 자동화
RUN apt update && \
    apt install -y curl ca-certificates python3 && \
    apt clean

# sshx 설치 스크립트를 사용하여 sshx 바이너리 설치
# -sS: curl의 진행 표시줄을 비활성화하고, 오류 발생 시 오류 메시지를 표시
# -f: HTTP 오류가 발생할 경우 자동 종료
RUN curl -sSf https://sshx.io/get | sh

# Render 서비스를 계속 실행하기 위한 더미 웹 콘텐츠 생성
WORKDIR /app
RUN echo "SSHX is running..." > index.html

# Render가 서비스를 유지하기 위해 최소 하나의 포트가 열려 있어야 함
EXPOSE 8080

# 더미 HTTP 서버를 백그라운드에서 실행하고, sshx serve --once를 주 프로세스로 실행
# sshx serve --once는 한 번의 연결이 종료되면 프로세스도 종료되도록 설정
CMD python3 -m http.server 8080 & \
    sshx

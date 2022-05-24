FROM openjdk:8  # 자바 개발 도구가 포함된 이미지
LABEL description="Echo IP Java Application"
EXPOSE 60433    # 노출되는 포트 번호 설정
RUN git clone https://github.com/iac-source/inbuilder.git # RUN으로 이미지 내부에서 소스 코드를 실행함
WORKDIR inbuilder   # Git clone으로 내려 받은 디렉토리를 현재 작업 공간으로 설정함
RUN chmod 700 mvnw  # mvnw에 실행 권한 설정
RUN ./mvnw clean package  # 메이븐 래퍼로 JAR 빌드
RUN mv target/app-in-host.jar /opt/app-in-image.jar # 빌드된 JAR을 /opt/app-in-image.jar로 옮김
WORKDIR /opt
ENTRYPOINT [ "java", "-jar", "app-in-image.jar" ]

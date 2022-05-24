# 1단계 : 자바 소스를 빌드해 JAR로 만듦
FROM openjdk:8 AS int-build # openjdk 이미지에 int-build라는 별칭을 붙임
LABEL description="Java Application builder"
RUN git clone https://github.com/iac-source/inbuilder.git
WORKDIR inbuilder
RUN chmod 700 mvnw
RUN ./mvnw clean package

# 2단계 : 빌드된 JAR를 경량화 이미지에 복사함
FROM gcr.io/distroless/java:8
LABEL description="Echo IP Java Application"
EXPOSE 60434  # 노출되는 포트 설정
# int-build(openjdk)에서 빌드가 완성된 app-in-host.jar을 distroless에 /opt/app-in-image.jar로 복사함
COPY --from=int-build inbuilder/target/app-in-host.jar /opt/app-in-image.jar
WORKDIR /opt
ENTRYPOINT [ "java", "-jar", "app-in-image.jar" ]

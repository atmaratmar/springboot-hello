FROM eclipse-temurin:17-jdk
COPY target/helloworld-1.0.0-SNAPSHOT.jar app.jar
ENTRYPOINT ["java","-jar","/app.jar"]

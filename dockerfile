FROM maven:3.9.9-eclipse-temurin-21 AS build

WORKDIR /app


COPY pom.xml .
RUN mvn -DskipTests dependency:go-offline


COPY . .
RUN mvn test package



FROM eclipse-temurin:21-jre

RUN useradd -m app
WORKDIR /app

COPY --from=build /app/target/*.jar /app/app.jar
RUN chown app:app /app/app.jar /app

USER app
ENTRYPOINT ["java","-jar","/app/app.jar"]

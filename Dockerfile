# First stage: build the application
FROM maven:3.8.3-openjdk-17-slim AS builder
WORKDIR /app
COPY . .
RUN mvn clean package -DskipTests

# Second stage: run the application

FROM eclipse-temurin:17-jre-alpine AS runner

WORKDIR /app
COPY --from=builder /app/target/*.jar app.jar

EXPOSE 8080

ENTRYPOINT ["java", "-jar", "app.jar"]

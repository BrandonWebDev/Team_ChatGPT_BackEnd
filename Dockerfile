# First stage: build the application
FROM maven:3.8.3-openjdk-17-slim AS builder
WORKDIR /app
COPY . .
RUN mvn clean package -DskipTests

# Second stage: run the application

FROM eclipse-temurin:17-jre-alpine AS runner

WORKDIR /app
COPY --from=builder /app/target/*.jar app.jar
ENV DB_USERNAME=kcb \
    DB_PASSWORD=kcb \
    DB_HOST=localhost \
    DB_PORT=3306 \
    DB_URL=jdbc:mysql://${DB_HOST}:${DB_PORT}/kcb \
    JWT_SECRET=secret \
    PORT=8080
EXPOSE ${PORT}

CMD ["java", "-jar", "app.jar"]

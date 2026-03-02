# Собираем фронтовый образ
FROM node:20-alpine AS front-builder

WORKDIR /front

# Слой зависимостей
COPY frontend/package*.json ./

RUN npm ci

# Слой сборки и тестов
COPY frontend/index.html \
     frontend/*.config.* \
     frontend/tsconfig*.json \
     ./
COPY frontend/public ./public
COPY frontend/src ./src

RUN npm run lint
RUN npm run type-check
RUN npm run build

FROM eclipse-temurin:21.0.10_7-jdk-jammy AS java-builder

WORKDIR /app

# Слой зависимостей
COPY ./gradlew \
     ./*.kts \
     ./versions.properties \
     ./

COPY ./gradle ./gradle

# RUN make install
RUN ./gradlew dependencies

# Слой сборки и тестов
COPY ./src ./src
COPY --from=front-builder /front/dist ./src/main/resources/static

# RUN make build
RUN ./gradlew build

# RUN make test
RUN ./gradlew test


FROM eclipse-temurin:21.0.10_7-jre-jammy AS runner

COPY --from=java-builder /app/build ./app

CMD ["java", "-jar", "/app/libs/project-devops-deploy-0.0.1-SNAPSHOT.jar"]

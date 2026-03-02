## Доска объявлений (IaC)

### Hexlet project

[![Actions Status](https://github.com/Sherman330Turbo/devops-engineer-from-scratch-project-315/actions/workflows/hexlet-check.yml/badge.svg)](https://github.com/Sherman330Turbo/devops-engineer-from-scratch-project-315/actions)
[![main](https://github.com/Sherman330Turbo/devops-engineer-from-scratch-project-315/actions/workflows/main.yml/badge.svg)](https://github.com/Sherman330Turbo/devops-engineer-from-scratch-project-315/actions/workflows/main.yml)

Учебный DevOps-проект на базе приложения «Доска объявлений».
Цель проекта: пройти полный путь от контейнеризации приложения до инфраструктуры в Yandex Cloud, CI/CD, мониторинга и централизованного сбора логов.

---

## Dockerhub

Образ доступен адресу:

https://hub.docker.com/repository/docker/sherman330turbo/hexlet-devops-project-315

---

## Архитектура (текущий шаг)

1. **Backend** — Spring Boot API.
2. **Frontend** — React Admin (Vite), собирается в статические ассеты.
3. **Контейнеризация**:
   - multi-stage `Dockerfile`;
   - отдельный stage для сборки frontend (lint, type-check, build);
   - отдельный stage для сборки backend (`gradle build`, `gradle test`);
   - минимальный runtime-образ с JRE и готовым jar.

На первом шаге подготовлен базовый артефакт проекта: Docker-образ, который запускает приложение и готов к публикации в реестр.

---

## Контейнерный реестр

- Реестр образов: `sherman330turbo/hexlet-devops-project-315`
- Тег по умолчанию: `latest` (через `DOCKER_TAG` в `Makefile`)

---

## Запуск контейнера

```bash
make docker-build
make docker-run
```

После запуска сервис доступен на:

- `http://localhost:8080` — приложение
- `http://localhost:9090/actuator/health` — management/health endpoint

Альтернативный запуск напрямую:

```bash
docker run --rm -p 8080:8080 -p 9090:9090 sherman330turbo/hexlet-devops-project-315:latest
```

---

## Доступные команды

```bash
# Backend
make install
make run
make test
make lint
make build

# Docker
make docker-build
make docker-run
make docker-push
```

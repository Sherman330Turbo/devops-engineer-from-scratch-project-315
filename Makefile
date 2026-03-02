DOCKER_TAG ?= sherman330turbo/hexlet-devops-project-315

test:
	./gradlew test

start: run

run:
	./gradlew bootRun

update-gradle:
	./gradlew wrapper --gradle-version 9.2.1

update-deps:
	./gradlew refreshVersions

install:
	./gradlew dependencies

build:
	./gradlew build

lint:
	./gradlew spotlessCheck

lint-fix:
	./gradlew spotlessApply

docker-build:
	docker build -t "$(DOCKER_TAG)" .

docker-start: docker-run

docker-run:
	docker run --rm \
		-p 8080:8080 \
		-p 9090:9090 \
		-e JAVA_OPTS="-Xms256m -Xmx512m -Dspring.profiles.active=prod" \
 		"$(DOCKER_TAG)"

docker-push:
	docker push "$(DOCKER_TAG)"

.PHONY: build

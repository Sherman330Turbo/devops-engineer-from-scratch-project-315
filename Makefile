IMAGE_NAME ?= sherman330turbo/hexlet-devops-project-315
IMAGE_TAG ?= latest

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
	docker build -t "$(IMAGE_NAME)" .

docker-start: docker-run

docker-run:
	docker run --rm \
		-p 8080:8080 \
		-p 9090:9090 \
		-e JAVA_OPTS="-Xms256m -Xmx512m -Dspring.profiles.active=prod" \
 		"$(IMAGE_NAME)"

docker-push:
	docker push "$(IMAGE_NAME)"

boot: ansible-install
	ansible-playbook \
	ansible/playbooks/bootstrap.yml

ansible-install:
	ansible-galaxy install -r ansible/requirements.yml

encrypt-secrets:
		ansible-vault encrypt \
			.secrets/prod.yml \
			--output ansible/group_vars/all/secrets.yml \
			--vault-password-file ansible/.vault_pass \
			--encrypt-vault-id default

deploy: ansible-install encrypt-secrets
	ansible-playbook \
		-e "image_name=$(IMAGE_NAME) image_tag=$(IMAGE_TAG)" \
		ansible/playbooks/deploy.yml

.PHONY: build

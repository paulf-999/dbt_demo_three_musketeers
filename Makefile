#!/usr/bin/env make

docker_compose_cmd := docker-compose run --rm
dbt_project_name := bike_shop
dbt_profile := --profiles-dir /work/profiles

installations: deps install clean

deps:
	$(info [+] Download the relevant dependencies)
	pip install docker
	brew install gettext
	brew link --force gettext
	brew install gnu-sed
.PHONY: deps

install:
	$(info [+] Install the relevant dependencies)
	cd bin/dbt_setup_automation && make
	make validate
.PHONY: install

clean:
	$(info [+] Remove any redundant files, e.g. downloads)
	rm .env

validate: .env
	$(info [+] Verify the connection to the source DB)
	${docker_compose_cmd} dbt debug ${dbt_profile}
.PHONY: validate

.env:
	touch .env
	docker-compose run --rm envvars validate
	docker-compose run --rm envvars envfile --overwrite
	docker-compose run --rm envvars ensure
.PHONY: .env

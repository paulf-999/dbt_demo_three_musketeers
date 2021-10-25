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

run_model:
	$(info [+] Run the DBT model)
	dbt run ${dbt_profile}

test_model:
	$(info [+] Test the DBT model. Note: this is a schema test only and is useful only for loading new data (enforces uniqueness))
	# prerequisite: populate ${DBT_PROJECT_NAME}/models/schema.yml with any desired tests
	dbt test ${dbt_profile}

data_test_model:
	$(info [+] Test the DBT model. Note: this tests the actual data against predefined business rules)
	# prerequisite: populate ${DBT_PROJECT_NAME}/models/schema.yml with any desired tests
	dbt test --data ${dbt_profile}

document_model:
	$(info [+] Document the DBT model)
	dbt docs generate ${dbt_profile}
	dbt docs serve --profiles-dir profiles

.env:
	touch .env
	${docker_compose_cmd} envvars validate
	${docker_compose_cmd} envvars envfile --overwrite
	${docker_compose_cmd} envvars ensure
.PHONY: .env

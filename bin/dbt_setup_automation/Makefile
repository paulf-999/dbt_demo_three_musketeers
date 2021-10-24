all: init_dbt_project setup_dbt_project_file copy_dbt_project_files

export DBT_PROFILE_NAME=dbt_svc_profile
export DBT_PROJECT_NAME=bike_shop
export DBT_MODEL=curated_db
export PROGRAM=BIKE_SHOP

test:
	echo "here!"

deps:
	$(info [+] Install dependencies (dbt))
	pip install --upgrade dbt
	brew install gettext
	brew link --force gettext
	brew install gnu-sed

init_dbt_project:
	$(info [+] Initialise dbt project)
	@echo
	###############################################################
	# call 'init_dbt_project'
	###############################################################
	@echo
	@[ "${DBT_PROJECT_NAME}" ] || ( echo "\nError: DBT_PROJECT_NAME variable is not set\n"; exit 1 )
	@[ "${DBT_PROFILE_NAME}" ] || ( echo "\nError: DBT_PROFILE_NAME variable is not set\n"; exit 1 )
	# populate profiles/profiles.yml with ${DBT_PROFILE_NAME} var
	@envsubst < templates/profiles.yml > profiles/profiles.yml
	@dbt init ${DBT_PROJECT_NAME} --profiles-dir=profiles 2>/dev/null
	# copy profiles and model dirs into project folder
	@cp -r profiles/ ${DBT_PROJECT_NAME}/profiles
	@cp -r models/ ${DBT_PROJECT_NAME}/models
	@cp -r tests/ ${DBT_PROJECT_NAME}/tests
	@cp -r macros/ ${DBT_PROJECT_NAME}/macros
	# copy schema.yml (data model tests) to project folder
	@cp schema.yml ${DBT_PROJECT_NAME}/models/
	@rm -r ${DBT_PROJECT_NAME}/models/example
	@echo

setup_dbt_project_file:
	$(info [+] generate profiles.yml inside project folder file)
	@echo
	# change profile name in dbt_project.yml file
	@sed -i -e "s/profile: 'default'/profile: '${DBT_PROFILE_NAME}'/g" ${DBT_PROJECT_NAME}/dbt_project.yml
	# change project name in dbt_project.yml file
	@sed -i -e 's/my_new_project/${DBT_PROJECT_NAME}/g' ${DBT_PROJECT_NAME}/dbt_project.yml
	@rm ${DBT_PROJECT_NAME}/dbt_project.yml-e
	@echo

copy_dbt_project_files:
	$(info [+] Copy generated dbt project files to parent 'dbt' folder)
	@cp -r ${DBT_PROJECT_NAME} ../../
	@rm -r ${DBT_PROJECT_NAME}

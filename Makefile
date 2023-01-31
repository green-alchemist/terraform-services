## 
SHELL = /bin/zsh
TF_PATH = "./services/strapi-admin"

SERVICES := $(shell git show --name-only --oneline ${CIRCLE_SHA1} | awk -F"/" '/^services\// {print $$2}' | grep -v README | sort -u)
ALL_SERVICES := $(shell for service in $(sort $(wildcard ./services/**/main.tf)); do echo $$service | cut -d/ -f3 | tr "\n" " "; done)

## experimental start
ENV ?= staging

GIT_COMMITS = $(shell git log | grep commit | awk '{print $$2}')
GIT_REFS = $(shell git reflog | awk '{print $$1}')
## experimental end


clean: ## Remove Terraform build files
	@echo "Cleaning terraform files"; \
	find . -name .terraform | xargs rm -rf; \

.PHONY: clean

init: clean ## Terraform Init
	@echo "Running terraform init"; \
	for service in ${SERVICES}; do \
		terraform -chdir=./services/$$service init; \
	done; \
	echo "Done running Terraform init"

.PHONY: init

plan: ## Terraform Plan add | tfmask before going to real production
	@echo "Running terraform plan"; \
	for service in ${SERVICES}; do \
		terraform -chdir=./services/$$service plan; \
	done; \
	echo "Done running Terraform plan"

.PHONY: plan

fmt: clean ## run terraform fmt to see diffs in formatting
	@echo "Running Terraform format to check code for formatting issues"; \
	for service in ${SERVICES}; do \
		terraform -chdir=./services/$$service fmt -check=true -write=false -diff=true; \
	done; \
	echo "Done running Terraform format"

.PHONY: fmt

fmt-all: clean ## run terraform fmt to see diffs in formatting
	@echo "Running Terraform format to check code for formatting issues"; \
	for service in ${ALL_SERVICES}; do \
		terraform -chdir=./services/$$service fmt -check=true -write=false -diff=true; \
	done; \
	echo "Done running Terraform format"

.PHONY: fmt-all

fmt-write: clean ## run terraform fmt write to correct any basic formatting issues
	@echo "Running Terraform format write to correct any basic formatting issues"; \
	for service in ${SERVICES}; do \
		terraform -chdir=./services/$$service fmt -write=true; \
	done; \
	echo "Done running Terraform format with write"

.PHONY: fmt-write

validate: clean## run terraform validate to validate the code
	@echo "Running Terraform validate to check code"; \
	for service in ${SERVICES}; do \
		terraform -chdir=./services/$$service init; \
		terraform -chdir=./services/$$service validate; \
	done; \
	echo "Done running Terraform validate"

.PHONY: validate

apply: clean ## Terraform Apply piped through `tfmask`
	@echo "Running terraform apply"; \
	for service in ${SERVICES}; do \
		terraform -chdir=./services/$$service init; \
		terraform -chdir=./services/$$service apply; \
	done; \
	echo "Done running Terraform Apply"

.PHONY: apply

destroy: ## Terraform Destroy
	@echo "Running terraform destroy"; \
	terraform -chdir=${TF_PATH} destroy

.PHONY: destroy


### ---------------------------------- ### 

services: ## display what services will be applied to
	@echo ${SERVICES}

.PHONY: services

commits: ## display what services will be applied to
	@echo ${GIT_COMMITS}

.PHONY: commits

all-services: ## generates a list of all services
	@echo ${ALL_SERVICES}

.PHONY: all-services

### ---------------------------------- ### 

documentation: ## generate terraform documentation
	@echo "# KC Terraform Services" > ./services/README.md; \
  	for service in ${ALL_SERVICES}; do \
    	echo "* [`basename $$service`](`basename $$service`/README.md)" >> ./services/README.md; \
			echo "Generating docs for $$service"; \
			terraform-docs  md table ./services/$$service > ./services/$$service/README.md; \
  	done; \
  	echo "\n## [Back](../README.md)\n" >> ./services/README.md \

.PHONY: documentation


test: ## for testing new methods
	@echo $(SERVICES)
.PHONY: test


help: ## show this usage
	@echo "\033[36mKC Terraform Services Makefile:\033[0m\nUsage: make [target]\n"; \
	grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

.PHONY: help
.DEFAULT_GOAL := help
## 
SHELL = /bin/zsh
ALL_MODULES := $(shell for module in $(sort $(wildcard ./modules/three-tier-deployment/**/main.tf)); do echo $$module | cut -d/ -f3 | tr "\n" " "; done)

PWD := $(shell pwd | rev |  cut -d/ -f1 | rev)

reverse = $(2) $(1)

rev_str = $(1) | rev 

foo = $(call reverse,a,b)
bar = $(call rev_str,baby)

REVERSE := $(shell echo reverse pwd)

# TF_PATH2 = "./terraform/dev/us-east-1/t2.micro/three-tier-deployment"
TF_PATH = "./services/strapi-admin"

SERVICES := $(shell git show --name-only --oneline ${CIRCLE_SHA1} | awk -F"/" '/^services\// {print $$2}' | grep -v README | sort -u)
ALL_SERVICES := $(shell for service in $(sort $(wildcard ./services/**/main.tf)); do echo $$service | cut -d/ -f3 | tr "\n" " "; done)
ENV ?= test
INIT_ARGS := -var environment=${ENV} -backend-config=services/$$service/environments/${ENV}/backend.tfvars


init: ## Terraform Init
	@echo "Running terraform init"; \
	terraform -chdir=${TF_PATH} init

.PHONY: init

plan: ## Terraform Plan
	@echo "Running terraform plan"; \
	terraform -chdir=${TF_PATH} plan

.PHONY: plan

# validate: ## Terraform Validate
# 	@echo "Running terraform validate"; \
# 	terraform -chdir=${TF_PATH} validate

# .PHONY: validate
# terraform init -get=true -reconfigure ${INIT_ARGS} services/$$service/src; \

validate: ## run terraform validate to validate the code
	echo "Running Terraform validate to check code"; \
	for service in ${SERVICES}; do \
	terraform -chdir=./services/$$service init; \
	terraform -chdir=./services/$$service validate; \
	done; \
	echo "Done running Terraform validate"

.PHONY: validate

apply: ## Terraform Apply
	@echo "Running terraform apply"; \
	terraform -chdir=${TF_PATH} apply

.PHONY: apply

destroy: ## Terraform Destroy
	@echo "Running terraform destroy"; \
	terraform -chdir=${TF_PATH} destroy

.PHONY: destroy

clean: ## Remove Terraform build files
	@echo "Cleaning terraform files"; \
	find ./ -name .terraform | xargs rm -rf

.PHONY: clean

test: ## testing makefile things
	@echo ${ALL_MODULES}
	@echo $(shell for folder in $(wildcard ./modules/**); do echo $$folder; list; done )
	@echo $(wildcard ./modules/**/**)
	@echo $(wildcard ../**)
	@echo ${foo}


.PHONY: test


here: ## more testing
	@echo $(MAKEFILE_LIST)
.PHONY: here

rev:
	@echo $(call rev_str,kyleconley)
	@set -e; \
	aws s3 ls;
.PHONY: rev






help: ## show this usage
	@echo "\033[36mKyle Conley Terraform Services Makefile:\033[0m\nUsage: make [target]\n"; \
	grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

.PHONY: help
.DEFAULT_GOAL := help
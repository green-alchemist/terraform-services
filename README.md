# Terraform Services Monorepo

This repository contains the Terraform configurations for managing the infrastructure of all services. It follows a monorepo pattern where each distinct piece of infrastructure (e.g., the Gatsby portfolio site, the Strapi CMS) is defined as a separate "service."

The primary goal of this repository is to provide a centralized, version-controlled, and automated way to provision and manage cloud infrastructure on AWS.

## Project Structure

The repository is organized into two main top-level directories:

* **`/services`**: Contains the core Terraform code for each individual service. Each subdirectory represents a self-contained set of resources.
* **`/environments`**: Contains the environment-specific configuration (`.tfvars` files) for each service. This is where you define the differences between environments like `staging` and `production` (e.g., instance sizes, domain names, etc.).

## Available Services
* [`_bootstrap`](./services/_bootstrap/README.md)
* [`portfolio-gatsby`](./services/portfolio-gatsby/README.md)
* [`strapi-admin`](./services/strapi-admin/README.md)

## Local Development

This project uses [Task](https://taskfile.dev/) as a command runner to simplify common Terraform operations. The following commands are available to be run from the root of the repository.

* `task fmt`: Formats all Terraform code recursively.
* `task validate-changed`: Validates only the services that have been changed on your current branch compared to `master`.
* `task plan-changed`: Creates a Terraform plan for the changed services against the `staging` environment by default.
* `task apply-changed`: Applies the plan for the changed services. **Note:** This is typically handled by the CI/CD pipeline.
* `task clean`: Removes all local Terraform cache files (`.terraform` directories and `.tfplans`).

To see a full list of available commands, run `task --list-all`.

## CI/CD Automation with CircleCI

This repository is configured with a CircleCI pipeline (`.circleci/config.yml`) that automates the deployment of both infrastructure and applications. The pipeline is divided into distinct workflows to handle different scenarios.

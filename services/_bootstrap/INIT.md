### The "Order of Operations": How to Run This

Your `task` commands are for managing your application services. This bootstrap process is a one-time prerequisite.

1.  **Create a Configuration File:** Inside `services/_bootstrap`, create a new file named `bootstrap.tfvars` with the names for your backend resources.

    ```terraform
    # services/_bootstrap/bootstrap.tfvars

    aws_region        = "us-east-1"
    aws_profile       = "your-sso-profile-name"
    state_bucket_name = "kc-portfolio-terraform-state-unique" # MUST be globally unique
    lock_table_name   = "kc-portfolio-terraform-lock"
    tags = {
      Project = "Portfolio-Backend"
    }
    ```

2.  **Run Terraform Manually (One Time Only):**
    Navigate into the `_bootstrap` directory and run the standard Terraform commands.

    ```bash
    cd services/_bootstrap
    terraform init
    terraform apply -var-file="./clients/portfolio.tfvars"
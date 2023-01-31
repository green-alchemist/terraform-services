module "remote_state" {
  source                  = "git@github.com:sigma-us/terraform-modules.git//modules/remote-state"
  dynamodb_table_name     = var.remote_state_dynamodb_table
  kms_key_alias           = "strapi-admin-tf-state"
  override_s3_bucket_name = true
  s3_bucket_name          = var.remote_state_bucket_name
  tags = {
    Terraform = "true"
    Service   = "strapi-admin"
  }
}
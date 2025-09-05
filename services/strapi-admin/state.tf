module "remote_state" {
  source              = "git@github.com:sigma-us/terraform-modules.git//modules/remote-state"
  dynamodb_table_name = "kc-terraform-lock"
  # kms_key_alias           = "kc-tf-state"
  override_s3_bucket_name = true
  s3_bucket_name          = "kc-tf-state"
  tags = {
    Terraform = "true"
    Service   = "all"
  }
}
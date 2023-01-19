module remote_state {
  # source = "git@github.com:sigma-us/terraform-modules.git//AWS/modules/remote-state"
  source = "../../../terraform-modules/AWS/modules/remote-state"
  dynamodb_table_name = "strapi-admin-tf-lock"
}
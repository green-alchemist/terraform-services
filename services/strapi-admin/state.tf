module remote_state {
  source = "git@github.com:sigma-us/terraform-modules.git//modules/remote-state"
  dynamodb_table_name = "strapi-admin-tf-lock"
}
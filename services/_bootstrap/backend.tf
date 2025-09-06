# This service intentionally uses a local backend because its job
# is to create the remote backend itself.
terraform {
  backend "local" {}
}

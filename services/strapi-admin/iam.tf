module "ecs_task_execution_role" {
  source    = "git@github.com:green-alchemist/terraform-modules.git//modules/ecs-task-execution-role"
  role_name = "strapi-admin-task-execution-role"
}
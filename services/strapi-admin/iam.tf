data "aws_caller_identity" "current" {}
data "aws_region" "current" {}


data "aws_iam_policy_document" "strapi_task_policy" {
  statement {
    effect = "Allow"
    actions = [
      # Service Discovery & Health Status Permissions
      "servicediscovery:RegisterInstance",
      "servicediscovery:DeregisterInstance",
      "servicediscovery:UpdateInstanceCustomHealthStatus",
      "servicediscovery:GetInstance",
      "servicediscovery:DiscoverInstances",
      "servicediscovery:GetInstancesHealthStatus",
      "servicediscovery:ListInstances",
      "servicediscovery:GetOperation",
      "route53:GetHealthCheck",
      "route53:CreateHealthCheck",
      "route53:DeleteHealthCheck",
      "route53:UpdateHealthCheck",

      # ECS Exec Permissions
      "ssmmessages:CreateControlChannel",
      "ssmmessages:CreateDataChannel",
      "ssmmessages:OpenControlChannel"
    ]
    resources = ["*"] # Scoped to task role, so this is acceptable.
  }
}

data "aws_iam_policy_document" "ecs_execution_policy" {
  statement {
    effect = "Allow"
    actions = [
      "ecr:GetAuthorizationToken",
      "ecr:BatchCheckLayerAvailability",
      "ecr:GetDownloadUrlForLayer",
      "ecr:BatchGetImage",
      "logs:CreateLogStream",
      "logs:PutLogEvents"
    ]
    resources = [
      "arn:aws:ssm:${data.aws_region.current.id}:${data.aws_caller_identity.current.account_id}:parameter/strapi/${var.environment}/env/*",
    ]
  }
}

module "ecs_roles" {
  source = "git@github.com:green-alchemist/terraform-modules.git//modules/ecs-task-execution-role"

  # 1. Define the Execution Role
  execution_role_name = "strapi-admin-${var.environment}-execution-role"
  execution_role_policy_jsons = {
    # SSMSecretsAccess = data.aws_iam_policy_document.ecs_execution_policy.json
  }

  attach_ssm_secrets_policy = true # Allow it to fetch secrets
  secrets_ssm_path          = "/strapi/${var.environment}/env/*"

  # 2. Define the Task Role
  task_role_name        = "strapi-admin-${var.environment}-task-role"
  task_role_policy_json = data.aws_iam_policy_document.strapi_task_policy.json
}
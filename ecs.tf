resource "aws_ecs_service" "service" {
  name            = local.service_name
  cluster         = var.ecs_cluster_arn
  task_definition = aws_ecs_task_definition.task.arn
  desired_count   = 1

  load_balancer {
    target_group_arn = aws_alb_target_group.tg.id
    container_name   = var.container_name
    container_port   = "3000"
  }

  dynamic "ordered_placement_strategy" {
    for_each = var.ordered_placement_strategies
    content {
      field = ordered_placement_strategy.value.field
      type  = ordered_placement_strategy.value.type
    }
  }

  force_new_deployment = true

  dynamic "capacity_provider_strategy" {
    for_each = var.capacity_provider_strategies
    content {
      capacity_provider = capacity_provider_strategy.value.capacity_provider
      weight            = capacity_provider_strategy.value.weight
      base              = capacity_provider_strategy.value.base
    }
  }

  lifecycle {
    ignore_changes = [desired_count, task_definition]
  }
}

resource "aws_ecs_task_definition" "task" {
  execution_role_arn    = var.execution_role_arn
  family                = local.service_name
  container_definitions = data.template_file.tpl.rendered
  task_role_arn         = aws_iam_role.task_role.arn
}

data "template_file" "tpl" {
  template = file("${path.module}/task-definition.json")
  vars = {
    image                   = data.aws_ecr_repository.repository.repository_url
    region                  = data.aws_region.current.name
    log_group               = var.cloudwatch_log_group
    container_name          = var.container_name
    project                 = var.project
    environment             = var.environment
    redis_host              = var.redis_host
    db_config               = var.db_config_secret_arn
    service_path            = var.service_path
    dummy_api_key           = (var.api_key_secret_arn == "" ?
    <<-EOF
    ,
    {
      "value": "your-secure-api-key", 
      "name": "API_KEY"
    }
    EOF
    : "")
    api_key_secret         = (var.api_key_secret_arn != "" ?
    <<-EOF
    ,
    {
      "valueFrom": "${var.api_key_secret_arn}", 
      "name": "API_KEY"
    }
    EOF
    : "")
  }
}

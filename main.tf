locals {
  project_env  = "${var.project}-${var.environment}"
  service_name = "${local.project_env}-${var.container_name}"
}

data "aws_region" "current" {}

data "aws_ecr_repository" "repository" {
  name = var.ecr_repository
}

variable "project" {
  description = "The name of the project"
  type        = string
}

variable "environment" {
  description = "The environment of the project"
  type        = string
}
 
variable "container_name" {
  description = "The name of the service"
  type        = string
  default     = "gamification-engine"
}

variable "service_path" {
  description = "The path of the service"
  type        = string
  default     = "game-eng"
}

variable "vpc_id" {
  description = "The ID of the VPC"
  type        = string
}

variable "lb_listener_arn" {
  description = "The ARN of the listener"
  type        = string
}

variable "lb_priority" {
  description = "The priority of the listener"
  type        = number
}

variable "lb_host_headers" {
  description = "The host headers of the listener"
  type        = list(string)
  default     = []
}

variable "ecs_cluster_arn" {
  description = "The ARN of the ECS cluster"
  type        = string
}

variable "capacity_provider_strategies" {
  description = "The capacity provider strategies"
  type = list(object({
    capacity_provider = string
    weight            = number
    base              = number
  }))

  default = []
}

variable "ordered_placement_strategies" {
  description = "The ordered placement strategies"
  type = list(object({
    field = string
    type  = string
  }))

  default = []
}

variable "api_key_secret_arn" {
  description = "The ARN of the database configuration"
  type        = string
  default     = ""
}

variable "db_config_secret_arn" {
  description = "The ARN of the database configuration"
  type        = string
}

variable "redis_host" {
  description = "The host of the Redis"
  type        = string
}

variable "ecr_repository" {
  description = "The name of the ECR repository"
  type        = string
}

variable "cloudwatch_log_group" {
  description = "The name of the CloudWatch log group"
  type        = string
}

variable "execution_role_arn" {
  description = "ARN of the execution role"
  type        = string
}

variable "task_role_policy_attachment_arns" {
  description = "ARNs of the task role policy attachments"
  type        = list(string)
  default     = []
}

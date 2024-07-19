resource "aws_iam_role" "task_role" {
  name = "${local.service_name}-task-role"

  assume_role_policy = <<EOF
{
  "Version": "2008-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Service": "ecs-tasks.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "attach" {
  for_each   = toset(var.task_role_policy_attachment_arns)
  role       = aws_iam_role.task_role.name
  policy_arn = each.value
}

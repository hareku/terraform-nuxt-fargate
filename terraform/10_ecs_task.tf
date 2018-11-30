#####################################
# ECS Task Settings
#####################################
# main
data "template_file" "main" {
  template = "${file("task/main.json")}"

  vars {
    app_name       = "${local.app_name}"
    aws_region     = "${local.aws_region}"
    rp_image_url   = "${aws_ecr_repository.h2o.repository_url}"
    web_image_url  = "${aws_ecr_repository.node.repository_url}"
    aws_logs_group = "${aws_cloudwatch_log_group.application.name}"
  }
}

resource "aws_ecs_task_definition" "main" {
  family                   = "${local.app_name}-main"
  container_definitions    = "${data.template_file.main.rendered}"
  execution_role_arn       = "${aws_iam_role.ecs_tasks.arn}"
  network_mode             = "awsvpc"
  cpu                      = 1024
  memory                   = 2048
  requires_compatibilities = ["FARGATE"]

  depends_on = [
    "aws_cloudwatch_log_group.application",
  ]
}

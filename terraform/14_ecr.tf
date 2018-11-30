#####################################
# ECR Settings
#####################################
resource "aws_ecr_repository" "h2o" {
  name = "${local.app_name}-h2o"
}

resource "aws_ecr_repository" "node" {
  name = "${local.app_name}-node"
}

#####################################
# ECR Lifecycle Policy Settings
#####################################
locals {
  lifecycle_policy = <<EOF
  {
    "rules": [
      {
        "rulePriority": 10,
        "description": "Expire images count more than 5",
        "selection": {
          "tagStatus": "any",
          "countType": "imageCountMoreThan",
          "countNumber": 5
        },
        "action": {
          "type": "expire"
        }
      }
    ]
  }
EOF
}

resource "aws_ecr_lifecycle_policy" "h2o" {
  repository = "${aws_ecr_repository.h2o.name}"

  policy = "${local.lifecycle_policy}"
}

resource "aws_ecr_lifecycle_policy" "node" {
  repository = "${aws_ecr_repository.node.name}"

  policy = "${local.lifecycle_policy}"
}

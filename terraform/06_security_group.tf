#####################################
# Security Group Settings
#####################################
# ELB
resource "aws_security_group" "elb" {
  name   = "${local.app_name}-elb"
  vpc_id = "${aws_vpc.this.id}"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags {
    Name = "${local.app_name}-elb"
  }
}

# ECS
resource "aws_security_group" "ecs" {
  name   = "${local.app_name}-ecs"
  vpc_id = "${aws_vpc.this.id}"

  ingress {
    from_port       = 8080
    to_port         = 8080
    protocol        = "tcp"
    security_groups = ["${aws_security_group.elb.id}"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags {
    Name = "${local.app_name}-ecs"
  }
}

# ELB egress to ECS
resource "aws_security_group_rule" "elb_egress_to_ecs" {
  security_group_id        = "${aws_security_group.elb.id}"
  source_security_group_id = "${aws_security_group.ecs.id}"
  type                     = "egress"
  from_port                = 8080
  to_port                  = 8080
  protocol                 = "tcp"
}

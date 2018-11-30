#####################################
# ALB Setting
#####################################
resource "aws_lb" "this" {
  name               = "${local.app_name}-alb"
  load_balancer_type = "application"
  internal           = false
  enable_http2       = true

  security_groups = ["${aws_security_group.elb.id}"]
  subnets         = ["${aws_subnet.elb_a.id}", "${aws_subnet.elb_c.id}"]

  access_logs {
    bucket  = "${aws_s3_bucket.elb_log.id}"
    prefix  = "ELBLog"
    enabled = true
  }

  tags {
    Name = "${local.app_name}-alb"
  }
}

#####################################
# ALB Target Settings
#####################################
resource "aws_lb_target_group" "http" {
  name        = "${local.app_name}-target-group"
  vpc_id      = "${aws_vpc.this.id}"
  port        = 8080
  protocol    = "HTTP"
  target_type = "ip"

  health_check {
    interval            = 60
    path                = "/"
    unhealthy_threshold = 2
  }

  tags {
    Name = "${local.app_name}-target-group"
  }
}

#####################################
# ALB Listener Settings
#####################################
resource "aws_lb_listener" "http" {
  load_balancer_arn = "${aws_lb.this.id}"
  port              = "80"
  protocol          = "HTTP"

  default_action {
    target_group_arn = "${aws_lb_target_group.http.arn}"
    type             = "forward"
  }
}

resource "aws_lb_listener" "https" {
  load_balancer_arn = "${aws_lb.this.id}"
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = "${aws_acm_certificate.alb.arn}"

  default_action {
    target_group_arn = "${aws_lb_target_group.http.arn}"
    type             = "forward"
  }
}

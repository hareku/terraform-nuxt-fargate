#####################################
# ACM Settings
#####################################
resource "aws_acm_certificate" "cloudfront" {
  provider          = "aws.us-east-1"
  domain_name       = "${local.domain}"
  validation_method = "DNS"
}

resource "aws_acm_certificate" "alb" {
  domain_name       = "${local.domain}"
  validation_method = "DNS"
}

#####################################
# Route53 Settings
#####################################
resource "aws_route53_record" "this" {
  zone_id = "${local.apex_hosted_zone_id}"
  name    = "${local.domain}"
  type    = "A"

  alias {
    name                   = "${aws_cloudfront_distribution.this.domain_name}"
    zone_id                = "${aws_cloudfront_distribution.this.hosted_zone_id}"
    evaluate_target_health = false
  }
}

resource "aws_route53_record" "cloudfront_acm" {
  count   = "${length(aws_acm_certificate.cloudfront.domain_validation_options)}"
  zone_id = "${local.apex_hosted_zone_id}"
  name    = "${lookup(aws_acm_certificate.cloudfront.domain_validation_options[count.index],"resource_record_name")}"
  type    = "${lookup(aws_acm_certificate.cloudfront.domain_validation_options[count.index],"resource_record_type")}"
  ttl     = "300"
  records = ["${lookup(aws_acm_certificate.cloudfront.domain_validation_options[count.index],"resource_record_value")}"]
}

resource "aws_route53_record" "alb_acm" {
  count   = "${length(aws_acm_certificate.alb.domain_validation_options)}"
  zone_id = "${local.apex_hosted_zone_id}"
  name    = "${lookup(aws_acm_certificate.alb.domain_validation_options[count.index],"resource_record_name")}"
  type    = "${lookup(aws_acm_certificate.alb.domain_validation_options[count.index],"resource_record_type")}"
  ttl     = "300"
  records = ["${lookup(aws_acm_certificate.alb.domain_validation_options[count.index],"resource_record_value")}"]
}

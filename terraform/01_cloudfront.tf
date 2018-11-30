#####################################
# CloudFront Settings
#####################################
resource "aws_cloudfront_distribution" "this" {
  origin {
    domain_name = "${aws_lb.this.dns_name}"
    origin_id   = "${local.cloudfrond_origin_id}"

    custom_origin_config {
      http_port              = 80
      https_port             = 443
      origin_protocol_policy = "match-viewer"
      origin_ssl_protocols   = ["TLSv1", "TLSv1.1", "TLSv1.2"]
    }
  }

  enabled     = true
  price_class = "PriceClass_All"
  aliases     = ["${local.domain}"]

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    ssl_support_method       = "sni-only"
    minimum_protocol_version = "TLSv1"

    acm_certificate_arn = "${aws_acm_certificate.cloudfront.arn}"
  }

  default_cache_behavior {
    allowed_methods        = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cached_methods         = ["GET", "HEAD"]
    target_origin_id       = "${local.cloudfrond_origin_id}"
    viewer_protocol_policy = "redirect-to-https"

    forwarded_values {
      query_string = true
      headers      = ["*"]

      cookies {
        forward = "all"
      }
    }

    min_ttl     = 0
    max_ttl     = 0
    default_ttl = 0
  }

  # Cache behavior with precedence 0
  ordered_cache_behavior {
    path_pattern           = "*.js"
    allowed_methods        = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cached_methods         = ["GET", "HEAD"]
    target_origin_id       = "${local.cloudfrond_origin_id}"
    viewer_protocol_policy = "redirect-to-https"

    forwarded_values {
      query_string = true
      headers      = ["Host"]

      cookies {
        forward = "none"
      }
    }

    min_ttl     = 0
    default_ttl = "${365 * 24 * 60 * 60}"
    max_ttl     = "${365 * 24 * 60 * 60}"
    compress    = true
  }

  # Cache behavior with precedence 1
  ordered_cache_behavior {
    path_pattern           = "*.png"
    allowed_methods        = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cached_methods         = ["GET", "HEAD"]
    target_origin_id       = "${local.cloudfrond_origin_id}"
    viewer_protocol_policy = "redirect-to-https"

    forwarded_values {
      query_string = true
      headers      = ["Host"]

      cookies {
        forward = "none"
      }
    }

    min_ttl     = 0
    default_ttl = "${365 * 24 * 60 * 60}"
    max_ttl     = "${365 * 24 * 60 * 60}"
    compress    = true
  }

  # Cache behavior with precedence 2
  ordered_cache_behavior {
    path_pattern           = "*.jpg"
    allowed_methods        = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cached_methods         = ["GET", "HEAD"]
    target_origin_id       = "${local.cloudfrond_origin_id}"
    viewer_protocol_policy = "redirect-to-https"

    forwarded_values {
      query_string = true
      headers      = ["Host"]

      cookies {
        forward = "none"
      }
    }

    min_ttl     = 0
    default_ttl = "${365 * 24 * 60 * 60}"
    max_ttl     = "${365 * 24 * 60 * 60}"
    compress    = true
  }
}

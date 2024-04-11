# creating Cloudfront distribution :
resource "aws_cloudfront_distribution" "cf_dist" {
  comment = "Cloudfront for tomcat Apache"
  web_acl_id = aws_wafv2_web_acl.WafWebAcl.arn
  enabled             = true
  origin {
    domain_name = aws_elb.web_elb.dns_name
    origin_id   = aws_elb.web_elb.dns_name
    custom_origin_config {
      http_port              = 80
      https_port             = 443
      origin_protocol_policy = "http-only"
      origin_ssl_protocols   = ["TLSv1.2"]
    }
  }
  default_cache_behavior {
    allowed_methods        = ["GET", "HEAD", "OPTIONS", "PUT", "POST", "PATCH", "DELETE"]
    cached_methods         = ["GET", "HEAD", "OPTIONS"]
    target_origin_id       = aws_elb.web_elb.dns_name
    viewer_protocol_policy = "redirect-to-https"
    forwarded_values {
      headers      = []
      query_string = true
      cookies {
        forward = "all"
      }
    }
  }
  restrictions {
    geo_restriction {
      restriction_type = "whitelist"
      locations        = [ "US", "CA", "JP", "KR", "GB" ]
    }
  }
  viewer_certificate {
    cloudfront_default_certificate = true
  }
}

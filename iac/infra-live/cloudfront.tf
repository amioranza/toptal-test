resource "aws_cloudfront_distribution" "web" {
  enabled             = true
  http_version        = "http2"
  is_ipv6_enabled     = true
  price_class         = "PriceClass_All"
  retain_on_delete    = false
  wait_for_deployment = true
  comment             = "CDN for web"

  default_cache_behavior {
    allowed_methods = [
      "GET",
      "HEAD",
    ]
    cache_policy_id = data.aws_cloudfront_cache_policy.no_cache.id
    cached_methods = [
      "GET",
      "HEAD",
    ]
    compress               = true
    default_ttl            = 0
    max_ttl                = 0
    min_ttl                = 0
    smooth_streaming       = false
    target_origin_id       = aws_alb.application_load_balancer.dns_name
    trusted_key_groups     = []
    trusted_signers        = []
    viewer_protocol_policy = "allow-all"
  }

  ordered_cache_behavior {
    allowed_methods = [
      "GET",
      "HEAD",
    ]
    cache_policy_id = aws_cloudfront_cache_policy.policy[0].id
    cached_methods = [
      "GET",
      "HEAD",
    ]
    compress               = true
    default_ttl            = 0
    max_ttl                = 0
    min_ttl                = 0
    path_pattern           = "public/*"
    smooth_streaming       = false
    target_origin_id       = aws_alb.application_load_balancer.dns_name
    trusted_key_groups     = []
    trusted_signers        = []
    viewer_protocol_policy = "allow-all"
  }

  origin {
    connection_attempts = 3
    connection_timeout  = 10
    domain_name         = aws_alb.application_load_balancer.dns_name
    origin_id           = aws_alb.application_load_balancer.dns_name

    custom_origin_config {
      http_port                = 80
      https_port               = 443
      origin_keepalive_timeout = 5
      origin_protocol_policy   = "http-only"
      origin_read_timeout      = 30
      origin_ssl_protocols = [
        "TLSv1.2",
      ]
    }
  }

  restrictions {
    geo_restriction {
      locations        = []
      restriction_type = "none"
    }
  }

  viewer_certificate {
    cloudfront_default_certificate = true
    minimum_protocol_version       = "TLSv1"
  }
}

resource "aws_cloudfront_cache_policy" "policy" {
  count       = local.env == "development" ? 1 : 0
  comment     = "Default caching"
  default_ttl = 86400
  max_ttl     = 31536000
  min_ttl     = 1
  name        = "CachingOptimized"

  parameters_in_cache_key_and_forwarded_to_origin {
    enable_accept_encoding_brotli = true
    enable_accept_encoding_gzip   = true

    cookies_config {
      cookie_behavior = "none"
    }

    headers_config {
      header_behavior = "none"
    }

    query_strings_config {
      query_string_behavior = "none"
    }
  }
}

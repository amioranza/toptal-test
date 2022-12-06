# locals {
#   web_nocache_behavior = {
#     viewer_protocol_policy      = "allow_all"
#     cached_methods              = ["GET", "HEAD"]
#     allowed_methods             = ["HEAD", "DELETE", "POST", "GET", "OPTIONS", "PUT", "PATCH"]
#     default_ttl                 = 60
#     min_ttl                     = 0
#     max_ttl                     = 86400
#     compress                    = true
#     forward_cookies             = "all"
#     forward_header_values       = ["*"]
#     forward_query_string        = true
#     lambda_function_association = []
#     cache_policy_id             = ""
#     origin_request_policy_id    = ""
#   }
# }

# module "cdn" {
#   source  = "cloudposse/cloudfront-cdn/aws"
#   version = "0.25.0"
#   name    = "web"

#   origin_protocol_policy = "match-viewer"
#   origin_domain_name     = aws_alb.application_load_balancer.dns_name
#   viewer_protocol_policy = "allow-all"
#   forward_headers        = ["Host", "Origin", "Access-Control-Request-Headers", "Access-Control-Request-Method"]
#   forward_query_string   = true
#   default_ttl            = 60
#   min_ttl                = 0
#   max_ttl                = 86400
#   compress               = true
#   cached_methods         = ["GET", "HEAD"]
#   allowed_methods        = ["GET", "HEAD", "OPTIONS"]
#   price_class            = "PriceClass_All"

#   # ordered_cache = [
#   #   merge(local.web_nocache_behavior, tomap({ "path_pattern" = "public/*" }))
#   # ]

# }

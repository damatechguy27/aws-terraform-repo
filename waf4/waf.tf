

resource "aws_wafv2_web_acl" "main" {
  name        = "combined-rules-web-acl"
  description = "Web ACL with combined rules to block IPs generating excessive 400 responses and other criteria"
  scope       = "REGIONAL" # Use "CLOUDFRONT" for CloudFront distributions

  default_action {
    allow {}
  }

  # Rate-based rule to block IPs generating too many 400 responses
  rule {
    name     = "block-400-abuse"
    priority = 1

    action {
      block {}
    }

    statement {
      rate_based_statement {
        limit              = 100 # Adjust this number based on your needs
        aggregate_key_type = "IP"
        scope_down_statement {
          byte_match_statement {
            field_to_match {
              body {}
            }
            positional_constraint = "CONTAINS"
            search_string         = "400"
            text_transformation {
              priority = 0
              type     = "NONE"
            }
          }
        }
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "Block400Abuse"
      sampled_requests_enabled   = true
    }
  }

  # Rate-based rule to block IPs making too many requests
  rule {
    name     = "rate-limit-rule"
    priority = 2

    action {
      block {}
    }

    statement {
      rate_based_statement {
        limit              = 200 # Adjust this number based on your needs
        aggregate_key_type = "IP"
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "RateLimitRule"
      sampled_requests_enabled   = true
    }
  }

  # Rule to block IPs generating too many 404 responses
  rule {
    name     = "block-404-abuse"
    priority = 3

    action {
      block {}
    }

    statement {
      rate_based_statement {
        limit              = 100 # Adjust as needed
        aggregate_key_type = "IP"
        scope_down_statement {
          byte_match_statement {
            field_to_match {
              body {}
            }
            positional_constraint = "CONTAINS"
            search_string         = "404"
            text_transformation {
              priority = 0
              type     = "NONE"
            }
          }
        }
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "Block404Abuse"
      sampled_requests_enabled   = true
    }
  }

  visibility_config {
    cloudwatch_metrics_enabled = true
    metric_name                = "CombinedRulesWebACL"
    sampled_requests_enabled   = true
  }
}

# Optional: Create an IP set for manual blocking
resource "aws_wafv2_ip_set" "blocked_ips" {
  name               = "blocked-ips"
  description        = "IPs manually blocked"
  scope              = "REGIONAL"
  ip_address_version = "IPV4"
  addresses          = [] # Add IPs here if you want to manually block them
}

# Optional: Rule to block IPs in the IP set
resource "aws_wafv2_web_acl_rule" "block_ip_set" {
  name     = "block-listed-ips"
  priority = 0

  action {
    block {}
  }

  statement {
    ip_set_reference_statement {
      arn = aws_wafv2_ip_set.blocked_ips.arn
    }
  }

  visibility_config {
    cloudwatch_metrics_enabled = true
    metric_name                = "BlockListedIPs"
    sampled_requests_enabled   = true
  }

  web_acl_id = aws_wafv2_web_acl.main.id
}

# Optional: Associate the Web ACL with an Application Load Balancer
# Uncomment and modify as needed
# resource "aws_wafv2_web_acl_association" "example" {
#   resource_arn = aws_lb.example.arn
#   web_acl_arn  = aws_wafv2_web_acl.main.arn
# }

# Optional: Associate the Web ACL with an API Gateway
# Uncomment and modify as needed
# resource "aws_apigatewayv2_api" "example" {
#   name          = "example-api"
#   protocol_type = "HTTP"
# }
# 
# resource "aws_wafv2_web_acl_association" "example" {
#   resource_arn = aws_apigatewayv2_stage.example.arn
#   web_acl_arn  = aws_wafv2_web_acl.main.arn
# }

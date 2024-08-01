# Final Version of WAF ACL script

# Create the "allowips" IP set
resource "aws_wafv2_ip_set" "allowips" {
  name               = "allowedips"
  description        = "IP set for allowed IPs"
  scope              = "REGIONAL"
  ip_address_version = "IPV4"
  addresses          = ["192.0.2.0/24", "198.51.100.0/24"]  # Replace with your allowed IP ranges
}

# Create the "allowvendor" IP set
resource "aws_wafv2_ip_set" "allowvendor" {
  name               = "allowedvendor"
  description        = "IP set for allowed vendor IPs"
  scope              = "REGIONAL"
  ip_address_version = "IPV4"
  addresses          = ["203.0.113.0/24"]  # Replace with your allowed vendor IP ranges
}

# Create the Web ACL
resource "aws_wafv2_web_acl" "acltest" {
  name        = "RateLimiterBlanket"
  description = "Example WAF Web ACL with rate-based rules"
  scope       = "REGIONAL"  # Use "CLOUDFRONT" for CloudFront distributions

  default_action {
    allow {}
  }

  # Rule 1: Block IPs in allowlists if they exceed 2000 requests in 5 minutes
  rule {
    name     = "RateLimit-allowed-IPs"
    priority = 1

    action {
      block {}
    }

    statement {
      rate_based_statement {
        limit              = 2000
        aggregate_key_type = "IP"
        evaluation_window_sec = 300

        scope_down_statement {
          or_statement {
            statement {
              ip_set_reference_statement {
                arn = aws_wafv2_ip_set.allowips.arn
              }
            }
            statement {
              ip_set_reference_statement {
                arn = aws_wafv2_ip_set.allowvendor.arn
              }
            }
          }
        }
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "RateLimit-allowed-IPs"
      sampled_requests_enabled   = true
    }
  }

  # Rule 2: Block IPs not in allowlists if they exceed 500 requests in 1 minute
  rule {
    name     = "RateLimit-nonallowed-IPs"
    priority = 2

    action {
      block {}
    }

    statement {
      rate_based_statement {
        limit              = 500
        aggregate_key_type = "IP"
        evaluation_window_sec = 60

        scope_down_statement {
          or_statement {
            statement {
              not_statement {
                statement {
                  ip_set_reference_statement {
                    arn = aws_wafv2_ip_set.allowips.arn
                  }
                  
                }
              }
            }
            statement {
              not_statement {
                statement {
                  ip_set_reference_statement {
                    arn = aws_wafv2_ip_set.allowvendor.arn
                  }
                }
              }
            }
          }
        }
      }
    }
    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "RateLimit-nonallowed-IPs"
      sampled_requests_enabled   = true
    }
  }

  visibility_config {
    cloudwatch_metrics_enabled = true
    metric_name                = "RateLimiterBlanket"
    sampled_requests_enabled   = true
  }
}


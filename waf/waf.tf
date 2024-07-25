# Create a WAF Web ACL
resource "aws_wafv2_web_acl" "example" {
  name        = "400-level-error-spike-protection"
  description = "Block IPs with high rates of 400-level errors"
  scope       = "REGIONAL"  # Appropriate for an Application Load Balancer

  default_action {
    allow {}
  }

  # Rule to count 400-level errors (403 and 404)
  rule {
    name     = "count-400-level-errors"
    priority = 1

    action {
      count {}
    }

    statement {
      or_statement {
        statement {
          byte_match_statement {
            search_string = "403"
            field_to_match {
              single_header {
                name = "status"
              }
            }
            text_transformation {
              priority = 0
              type     = "NONE"
            }
            positional_constraint = "EXACTLY"
          }
        }
        statement {
          byte_match_statement {
            search_string = "404"
            field_to_match {
              single_header {
                name = "status"
              }
            }
            text_transformation {
              priority = 0
              type     = "NONE"
            }
            positional_constraint = "EXACTLY"
          }
        }
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "Count400LevelErrors"
      sampled_requests_enabled   = true
    }
  }

  # Rate-based rule to block IPs with high rates of 400-level errors
  rule {
    name     = "block-high-400-level-rate"
    priority = 2

    action {
      block {}
    }

    statement {
      rate_based_statement {
        limit              = 100
        aggregate_key_type = "IP"
        scope_down_statement {
          or_statement {
            statement {
              byte_match_statement {
                search_string = "403"
                field_to_match {
                  single_header {
                    name = "status"
                  }
                }
                text_transformation {
                  priority = 0
                  type     = "NONE"
                }
                positional_constraint = "EXACTLY"
              }
            }
            statement {
              byte_match_statement {
                search_string = "404"
                field_to_match {
                  single_header {
                    name = "status"
                  }
                }
                text_transformation {
                  priority = 0
                  type     = "NONE"
                }
                positional_constraint = "EXACTLY"
              }
            }
          }
        }
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "BlockHigh400LevelRate"
      sampled_requests_enabled   = true
    }
  }

  visibility_config {
    cloudwatch_metrics_enabled = true
    metric_name                = "400LevelErrorSpikeProtection"
    sampled_requests_enabled   = true
  }
}

resource "aws_wafv2_web_acl" "wafv2" {
  name        = "400-series-error-protection"
  description = "Block IPs with high rates of 400 series errors"
  scope       = "REGIONAL"

  default_action {
    allow {}
  }

  # Rule to count 400 series errors
  rule {
    name     = "count-400-series-errors"
    priority = 1

    action {
      count {}
    }

    statement {
      regex_pattern_set_reference_statement {
        arn = aws_wafv2_regex_pattern_set.four_hundred_series.arn
        field_to_match {
          single_header {
            name = "status"
          }
        }
        text_transformation {
          priority = 0
          type     = "NONE"
        }
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "Count400SeriesErrors"
      sampled_requests_enabled   = true
    }
  }

  # Rate-based rule to block IPs with high rates of 400 series errors
  rule {
  name     = "block-high-400-series-rate"
  priority = 2

  action {
    block {}
  }

  statement {
    rate_based_statement {
      limit              = 100
      aggregate_key_type = "IP"
      scope_down_statement {
        byte_match_statement {
          field_to_match {
            single_header {
              name = "status"
            }
          }
          positional_constraint = "EXACTLY"
          search_string         = "4[0-9][0-9]"
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
    metric_name                = "BlockHigh400Rate"
    sampled_requests_enabled   = true
  }
}


  visibility_config {
    cloudwatch_metrics_enabled = true
    metric_name                = "400SeriesErrorProtection"
    sampled_requests_enabled   = true
  }
}

# Regex pattern set for matching status codes starting with '4'
resource "aws_wafv2_regex_pattern_set" "four_hundred_series" {
  name        = "FourHundredSeriesStatusCodes"
  scope       = "REGIONAL"
  description = "Pattern set for 400 series HTTP status codes"

  regular_expression {
    regex_string = "^4\\d{2}$"
  }
}
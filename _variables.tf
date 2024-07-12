
variable "waf_cloudfront_enable" {
  type        = bool
  description = "Enable WAF for Cloudfront distribution"
  default     = false
}

variable "waf_regional_enable" {
  type        = bool
  description = "Enable WAFv2 to ALB, API Gateway or AppSync GraphQL API"
  default     = false
}

variable "metrics_enabled" {
  type        = bool
  description = "Enable cloudwatch mettrics"
  default     = true
}

variable "sampled_requests_enabled" {
  type        = bool
  description = "Store sample web requests that match the rules"
  default     = true
}

variable "logs_enable" {
  type        = bool
  description = "Enable logs"
  default     = false
}

variable "logs_retension" {
  type        = number
  description = "Specifies the number of days you want to retain log events in the specified log group. Possible values are: 1, 3, 5, 7, 14, 30, 60, 90, 120, 150, 180, 365, 400, 545, 731, 1827, 3653, and 0. If you select 0, the events in the log group are always retained and never expire."
  default     = 90
}

variable "global_rule" {
  description = "Cloudfront WAF Rule Name"
  type        = string
  default     = ""
}

variable "regional_rule" {
  description = "Regional WAF Rules for ALB and API Gateway"
  type        = string
  default     = ""
}

variable "default_action" {
  type    = string
  default = "block"
}

variable "default_action_cloudfront" {
  type    = string
  default = "allow"
}

variable "scope" {
  type        = string
  description = "The scope of this Web ACL. Valid options: CLOUDFRONT, REGIONAL(ALB)."
}

########## Associate WAFv2 Rules to CloudFront, ALB or API Gateway

variable "web_acl_id" {
  description = "Specify a web ACL ARN to be associated in CloudFront Distribution / # Optional WEB ACLs (WAF) to attach to CloudFront"
  type        = string
  default     = null
}

variable "associate_waf" {
  type        = bool
  description = "Whether to associate an ALB with the WAFv2 ACL."
  default     = false
}

variable "resource_arn" {
  type        = list(string)
  description = "ARN of the ALB to be associated with the WAFv2 ACL."
  default     = []
}

########## Statement Rules

variable "byte_match_statement_rules" {
  type = list(object({
    name     = string
    priority = number
    action   = string
    byte_matchs = list(object({
      positional_constraint = string
      search_string         = string
    }))
    byte_match_statement = list(object({
      all_query_arguments   = string
      body                  = string
      method                = string
      query_string          = string
      single_header         = string
      single_query_argument = string
      uri_path              = string
    }))
    text_transformation = list(object({
      priority = string
      type     = string
    }))
    visibility_config = optional(object({
      metrics_enabled = optional(bool, true)
      sampled_requests_enabled = optional(bool, true)
    }), {})
  }))
}

variable "geo_match_statement_rules" {
  type = list(object({
    name          = string
    priority      = string
    action        = string
    country_codes = list(string)
    visibility_config = optional(object({
      metrics_enabled = optional(bool, true)
      sampled_requests_enabled = optional(bool, true)
    }), {})
  }))
}

variable "ip_set_reference_statement_rules" {
  type = list(object({
    name     = string
    priority = string
    action   = string
    ip_set   = optional(list(string), [])
    ip_set_arn = optional(string)
    ip_set_reference_statement = optional(object({
      fallback_behavior = string
      header_name       = string
      position          = string
    }))
    visibility_config = optional(object({
      metrics_enabled = optional(bool, true)
      sampled_requests_enabled = optional(bool, true)
    }), {})
  }))
}

variable "managed_rule_group_statement_rules" {
  type = list(object({
    name     = string
    priority = string
    override_action = optional(string, "none")
    managed_rule_group_statement = list(object({
      name                       = string
      vendor_name                = string
      block_rule_action_override = optional(list(string), [])
      count_rule_action_override = optional(list(string), [])
    }))
    visibility_config = optional(object({
      metrics_enabled = optional(bool, true)
      sampled_requests_enabled = optional(bool, true)
    }), {})
  }))
}

variable "rate_based_statement_rules" {
  type = list(object({
    name     = string
    priority = string
    action   = string
    rate_based = list(object({
      aggregate_key_type = string
      limit              = number
    }))
    rate_based_statement = list(object({
      fallback_behavior = string
      header_name       = string
    }))
    visibility_config = optional(object({
      metrics_enabled = optional(bool, true)
      sampled_requests_enabled = optional(bool, true)
    }), {})
  }))
}

variable "regex_pattern_set_reference_statement_rules" {
  type = list(object({
    name      = string
    priority  = string
    action    = string
    regex_set = list(string)
    regex_pattern_set_reference_statement = list(object({
      all_query_arguments   = string
      body                  = string
      method                = string
      query_string          = string
      single_header         = string
      single_query_argument = string
      uri_path              = string
    }))
    text_transformation = list(object({
      priority = number
      type     = string
    }))
    visibility_config = optional(object({
      metrics_enabled = optional(bool, true)
      sampled_requests_enabled = optional(bool, true)
    }), {})
  }))
}

variable "size_constraint_statement_rules" {
  type = list(object({
    name                = string
    priority            = string
    action              = string
    comparison_operator = string
    size                = number
    size_constraint_statement = list(object({
      all_query_arguments   = string
      body                  = string
      method                = string
      query_string          = string
      single_header         = string
      single_query_argument = string
      uri_path              = string
    }))
    text_transformation = list(object({
      priority = number
      type     = string
    }))
    visibility_config = optional(object({
      metrics_enabled = optional(bool, true)
      sampled_requests_enabled = optional(bool, true)
    }), {})
  }))
}

variable "sqli_match_statement_rules" {
  type = list(object({
    name     = string
    priority = string
    action   = string
    sqli_match_statement = list(object({
      all_query_arguments   = string
      body                  = string
      method                = string
      query_string          = string
      single_header         = string
      single_query_argument = string
      uri_path              = string
    }))
    text_transformation = list(object({
      priority = number
      type     = string
    }))
    visibility_config = optional(object({
      metrics_enabled = optional(bool, true)
      sampled_requests_enabled = optional(bool, true)
    }), {})
  }))
}

variable "xss_match_statement_rules" {
  type = list(object({
    name     = string
    priority = string
    action   = string
    xss_match_statement = list(object({
      all_query_arguments   = string
      body                  = string
      method                = string
      query_string          = string
      single_header         = string
      single_query_argument = string
      uri_path              = string
    }))
    text_transformation = list(object({
      priority = number
      type     = string
    }))
    visibility_config = optional(object({
      metrics_enabled = optional(bool, true)
      sampled_requests_enabled = optional(bool, true)
    }), {})
  }))
}

variable "user_defined_rule_group_statement_rules" {
  type = list(object({
    name            = string
    priority        = string
    override_action = optional(string, "none")
    rule_group_arn  = optional(string)
    visibility_config = optional(object({
      metrics_enabled          = optional(bool, true)
      sampled_requests_enabled = optional(bool, true)
    }), {})
  }))
  default = []
}

variable "logging_redacted_fields" {
  type = list(object({
    method                = string
    query_string          = string
    single_header         = string
    uri_path              = string
  }))
}

variable "logging_filter" {
  type = list(object({
    default_behavior = string
    filter = list(object({
      behavior    = string
      requirement = string
      condition = list(object({
        action_condition     = optional(string)
        label_name_condition = optional(string)
      }))
    }))
  }))
}

variable "environment_name" {
  description = "Name of the environment"
  default     = ""
  type        = string
}

variable "log_destination" {
  description = "Use s3 bucket or kinesis stream as waf logs destination"
  default     = false
  type        = bool
}

variable "log_destination_arn" {
  description = "s3 bucket or kinesis stream arn for waf logs"
  default     = []
  type        = list(string)
}
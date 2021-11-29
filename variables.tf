variable "name" {
  description = "Name for CloudTrail trail. Used in naming some connected resources."
  type = string
}

variable "enable_logging" {
  description = "Enables logging on CloudTrail trail."
  type = bool
  default = true
}

variable "s3_key_prefix" {
  description = "Key prefix on S3 bucket for log delivery."
  type = string
  default = ""
}

variable "s3_kms_key" {
  description = "ARN of KMS key used to encrypt logs delivered to S3 bucket."
  type = string
  default = ""
}

variable "sns_topic_name" {
  description = "Name of the SNS topic used to deliver log delivery notification."
  type = string
  default = ""
}

variable "include_global_service_events" {
  description = "Include global services like IAM and S3."
  type = bool
  default = true
}

variable "is_multi_region_trail" {
  description = "Create trail in all other regions or only current one."
  type = bool
  default = false
}

variable "is_organization_trail" {
  description = "Collects events from all accounts in organization."
  type = bool
  default = false
}

variable "enable_log_file_validation" {
  description = "Enables validation of delivered log files."
  type = bool
  default = false
}

variable "event_selectors" {
  description = "Basic event selectors for CloudTrail trail."
  type = any
  default = []
}

variable "advanced_event_selectors" {
  description = "Advanced event selectors for CloudTrail trail."
  type = any
  default = []
}

variable "insight_selector" {
  description = "Enable Insight selector for CloudTrail trail."
  type = bool
  default = false
}

# bucket variables
variable "lifecycle_rule" {
  description = "A configuration of object lifecycle management"
  type        = list(any)
  default     = []
}

variable "force_destroy" {
  description = "Force destroy true|false"
  type        = bool
  default     = false
}

variable "bucket_policy" {
  description = "Additional bucket policy statements."
  type        = any
  default     = [
    {
      "Sid": "AWSCloudTrailAclCheck20150319",
      "Effect": "Allow",
      "Principal": {"Service": "cloudtrail.amazonaws.com"},
      "Action": "s3:GetBucketAcl",
      "Resource": ""
    },
    {
      "Sid": "AWSCloudTrailWrite20150319",
      "Effect": "Allow",
      "Principal": {"Service": "cloudtrail.amazonaws.com"},
      "Action": "s3:PutObject",
      "Resource": "",
      "Condition": {
        "StringEquals": {
          "s3:x-amz-acl": "bucket-owner-full-control"
        }
      }
    }
  ]
}

# cloudwatch log group variables
variable "enable_cloudwatch" {
  description = "Enables cloudwatch event delivery."
  type = bool
  default = false
}

variable "cw_log_retention" {
  description = "Number of days for log retention, 0 for indefinite."
  type = number
  default = 0
}

variable "cloudwatch_kms_key_id" {
  description = "KMS key ARN used for encypting logs in CloudWatch."
  type = string
  default = ""
}
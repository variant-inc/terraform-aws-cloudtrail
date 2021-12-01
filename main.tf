module "aws_s3" {
  source = "github.com/variant-inc/terraform-aws-s3?ref=master"

  bucket_prefix  = format("%s-", var.name)
  force_destroy  = var.force_destroy
  bucket_policy  = var.bucket_policy
  lifecycle_rule = var.lifecycle_rule
}

resource "aws_cloudwatch_log_group" "group" {
  count = var.enable_cloudwatch ? 1 : 0

  name              = format("aws-cloudtrail-logs-%s", var.name)
  retention_in_days = var.cw_log_retention
  kms_key_id        = length(var.cloudwatch_kms_key_id) != 0 ? var.cloudwatch_kms_key_id : null
}

resource "aws_iam_role" "cloudwatch" {
  count = var.enable_cloudwatch ? 1 : 0

  name = format("%s-cloudwatch-role", var.name)
  assume_role_policy = jsonencode({
    "Version" = "2012-10-17"
    "Statement" = [
      {
        "Sid"    = "CloudTrailAssumeRole"
        "Effect" = "Allow"
        "Principal" = {
          "Service" = "cloudtrail.amazonaws.com"
        }
        "Action" = "sts:AssumeRole"
      }
    ]
  })

  inline_policy {
    name = "cloudtrail-cloudwatch-policy"
    policy = jsonencode({
      "Version" = "2012-10-17"
      "Statement" = [
        {
          "Sid"    = "stepFunctionAccess"
          "Effect" = "Allow"
          "Action" = ["logs:CreateLogStream", "logs:PutLogEvents"]
          "Resource" = [
            aws_cloudwatch_log_group.group[0].arn,
            format("%s:*", aws_cloudwatch_log_group.group[0].arn)
          ]
        }
      ]
    })
  }
}

resource "aws_cloudtrail" "cloudtrail" {
  name           = var.name
  enable_logging = var.enable_logging
  s3_bucket_name = module.aws_s3.bucket_name
  s3_key_prefix  = var.s3_key_prefix
  kms_key_id     = length(var.s3_kms_key) != 0 ? var.s3_kms_key : null
  sns_topic_name = length(var.sns_topic_name) != 0 ? var.sns_topic_name : null

  include_global_service_events = var.include_global_service_events
  is_multi_region_trail         = var.is_multi_region_trail
  is_organization_trail         = var.is_organization_trail

  enable_log_file_validation = var.enable_log_file_validation
  cloud_watch_logs_group_arn = var.enable_cloudwatch ? format("%s:*", aws_cloudwatch_log_group.group[0].arn) : null
  cloud_watch_logs_role_arn  = var.enable_cloudwatch ? aws_iam_role.cloudwatch[0].arn : null

  dynamic "event_selector" {
    for_each = var.event_selectors

    content {
      include_management_events = lookup(event_selector.value, "include_management_events", false)
      read_write_type           = lookup(event_selector.value, "read_write_type", "All")
      dynamic "data_resource" {
        for_each = lookup(event_selector.value, "data_resources", [])

        content {
          type   = lookup(data_resource.value, "type", null)
          values = lookup(data_resource.value, "values", null)
        }
      }
    }
  }

  dynamic "advanced_event_selector" {
    for_each = var.advanced_event_selectors

    content {
      name = lookup(advanced_event_selector.value, "name", null)
      dynamic "field_selector" {
        for_each = lookup(advanced_event_selector.value, "field_selector", [])

        content {
          field           = lookup(field_selector.value, "field", null)
          equals          = lookup(field_selector.value, "equals", null)
          not_equals      = lookup(field_selector.value, "not_equals", null)
          starts_with     = lookup(field_selector.value, "starts_with", null)
          not_starts_with = lookup(field_selector.value, "not_starts_with", null)
          ends_with       = lookup(field_selector.value, "ends_with", null)
          not_ends_with   = lookup(field_selector.value, "not_ends_with", null)
        }
      }
    }
  }

  dynamic "insight_selector" {
    for_each = var.insight_selector ? [true] : []

    content {
      insight_type = "ApiCallRateInsight"
    }
  }
}
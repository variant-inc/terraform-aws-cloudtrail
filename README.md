# Terraform CloudTrail trail module

- [Terraform CloudTrail trail module](#terraform-cloudtrail-trail-module)
  - [Input Variables](#input-variables)
    - [name](#name)
    - [tags](#tags)
    - [enable_logging](#enable_logging)
    - [s3_key_prefix](#s3_key_prefix)
    - [s3_kms_key](#s3_kms_key)
    - [sns_topic_name](#sns_topic_name)
    - [include_global_service_events](#include_global_service_events)
    - [is_multi_region_trail](#is_multi_region_trail)
    - [is_organization_trail](#is_organization_trail)
    - [enable_log_file_validation](#enable_log_file_validation)
    - [event_selectors](#event_selectors)
    - [advanced_event_selectors](#advanced_event_selectors)
    - [insight_selector](#insight_selector)
    - [lifecycle_rule](#lifecycle_rule)
    - [force_destroy](#force_destroy)
    - [bucket_policy](#bucket_policy)
    - [enable_cloudwatch](#enable_cloudwatch)
    - [cw_log_retention](#cw_log_retention)
    - [cloudwatch_kms_key_id](#cloudwatch_kms_key_id)
  - [Examples](#examples)
    - [`main.tf`](#maintf)
    - [`terraform.tfvars.json`](#terraformtfvarsjson)
    - [`provider.tf`](#providertf)
    - [`variables.tf`](#variablestf)
    - [`outputs.tf`](#outputstf)

## Input Variables
| Name     | Type    | Default   | Example     | Notes   |
| -------- | ------- | --------- | ----------- | ------- |
| name | string |  | "test-trail" |  |
| tags | map(string) | {} | {"environment": "prod"} | |
| enable_logging | bool | true | false |  |
| s3_key_prefix | string | "" | "logs/" |  |
| s3_kms_key | string | "" | "arn:aws:kms:us-east-1:319244236588:key/dfed962d-0968-42b4-ad36-7762dac7ca20" |  |
| sns_topic_name | string | "" | "arn:aws:sns:us-east-1:319244236588:test-sns-topic" |  |
| include_global_service_events | bool | true | false |  |
| is_multi_region_trail | bool | false | true |  |
| is_organization_trail | bool | false | true |  |
| enable_log_file_validation | bool | false | true |  |
| event_selectors | any | [] | `see below` |  |
| advanced_event_selectors | any | [] | `see below` |  |
| insight_selector | bool | false | true |  |
| lifecycle_rule | list(any) | [] | [S3 module]<https://github.com/variant-inc/terraform-aws-s3#lifecycle_rule> |  |
| force_destroy | bool | fasle | [S3 module]<https://github.com/variant-inc/terraform-aws-s3#force_destroy> |  |
| bucket_policy | any | `see below` | [S3 module]<https://github.com/variant-inc/terraform-aws-s3#bucket_policy> |  |
| enable_cloudwatch | bool | false | true |  |
| cw_log_retention | number | 0 | 60 |  |
| cloudwatch_kms_key_id | string | "" | "arn:aws:kms:us-east-1:319244236588:key/dfed962d-0968-42b4-ad36-7762dac7ca20" |  |

### name
Name of the CloudTrail trail
```json
"name": "<trail name>"
```

### tags
Tags for created bucket.
```json
"tags": {<map of tag keys and values>}
```

Default:
```json
"tags": {}
```

### enable_logging
Enables or disables trail logging. If set to false events are not captured.
```json
"enable_logging": <true or false>
```

Default:
```json
"enable_logging": true
```

### s3_key_prefix
Key prefix for storing CloudTrail logs inside the S3 bucket.
```json
"s3_key_prefix": "<S3 key prefix for storing logs>"
```

Default:
```json
"s3_key_prefix": ""
```

### s3_kms_key
ARN of KMS key used to encrypt logs stored on S3 bucket.
```json
"s3_kms_key": "<KMS key ARN>"
```

Default:
```json
"s3_kms_key": ""
```

### sns_topic_name
ARN of SNS topic used to notify on newly delivered logs on S3.
```json
"sns_topic_name": "<ARN of SNS topic>"
```

Default:
```json
"sns_topic_name": ""
```

### include_global_service_events
Enables capture of events for global services like IAM, S3, Route53...
```json
"include_global_service_events": <true or false>
```

Default:
```json
"include_global_service_events": true
```

### is_multi_region_trail
Specifies if same trail shoul be created in other regions inside the account.
```json
"is_multi_region_trail": <true or false>
```

Default:
```json
"is_multi_region_trail": false
```

### is_organization_trail
Sepcifies if the CloudTrial trail captures events from all accounts inside the organization.
```json
"is_organization_trail": <true or false>
```

Default:
```json
"is_organization_trail": false
```

### enable_log_file_validation
Includes validation data for logs delivered on S3 bucket.
```json
"enable_log_file_validation": <true or false>
```

Default:
```json
"enable_log_file_validation": false
```

### event_selectors
List of basic event selectors. Consult the documentation for supported fields and values.
[AWS Docs]<https://docs.aws.amazon.com/awscloudtrail/latest/APIReference/API_EventSelector.html>
[Terraform Docs]<https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudtrail#event_selector>
```json
"event_selectors": [<list of event selectors>]
```

Default:
```json
"event_selectors": []
```

### advanced_event_selectors
List of advanced event selectors. Consult the documentation for supported fields and values.
[AWS Docs]<https://docs.aws.amazon.com/awscloudtrail/latest/APIReference/API_AdvancedEventSelector.html>
[AWS Docs 2]<https://docs.aws.amazon.com/awscloudtrail/latest/APIReference/API_AdvancedFieldSelector.html>
[Terraform Docs]<https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudtrail#advanced_event_selector>
```json
"advanced_event_selectors": [<list of advanced event selectors>]
```

Default:
```json
"advanced_event_selectors": []
```

### insight_selector
Includes or excludes insights events.
```json
"insight_selector": <true or false>
```

Default:
```json
"insight_selector": false
```

### lifecycle_rule
Lifecycle rule for S3 bucket.
[S3 module]<https://github.com/variant-inc/terraform-aws-s3#lifecycle_rule>
```json
"lifecycle_rule": [{
  "prefix": "<prefix on which to apply rule>",
  "enabled": <true or false>,
  "abort_incomplete_multipart_upload_days": <days for deletion of failed multipar uploads, minimum 1>,
  "expiration": [{
    "days": <days for current version expiration>,
    "expired_object_delete_marker": <true or false>
  }],
  "transition_storage_class": [{
    "days": <days for current version transition>,
    "storage_class": "<storage class for current version transition>"
  }],
  "noncurrent_version_transition": [{
    "days": <days for noncurrent version transition>,
    "storage_class": "<storage class for noncurrent version transition>"
  }],
  "noncurrent_version_expiration_days": <days for noncurrent version expiration>
}]
```

Default:
```json
"lifecycle_rule": []
```

### force_destroy
Force destroy for S3 bucket.
[S3 module]<https://github.com/variant-inc/terraform-aws-s3#force_destroy>
```json
"force_destroy": <true or false>
```

Default:
```json
"force_destroy": false
```

### bucket_policy
Custom bucket level policy, by default used to allow write for CloudTrail.
[S3 module]<https://github.com/variant-inc/terraform-aws-s3#bucket_policy>
```json
"bucket_policy": [
  {
    "Sid" : "<policy SID>",
    "Effect" : "<Allow or Deny>",
    "Principal" : "<single or list of principals>",
    "Action" : "<single action or list of actions>",
    "Condition" : {
      <any kind of supported condition or remove this block>
    }
  }
]
```

Default:
```json
"bucket_policy": [
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
```

### enable_cloudwatch
Enables delivery of CloudTrail events to CloudWatch.
```json
"variableName": <true or false>
```

Default:
```json
"variableName": false
```

### cw_log_retention
Number of days the logs are kept in the CloudWatch logs.
0 for infinite.
```json
"cw_log_retention": <number of days>
```

Default:
```json
"cw_log_retention": 0
```

### cloudwatch_kms_key_id
KMS key ARN used for encypting logs in CloudWatch.
```json
"cloudwatch_kms_key_id": "<KMS key ARN>"
```

Default:
```json
"cloudwatch_kms_key_id": ""
```

## Examples
### `main.tf`
```terarform
module "cloudtrail" {
  source = "github.com/variant-inc/terraform-aws-cloudtrail?ref=v1"

  name            = var.name
  enable_logging  = var.enable_logging
  s3_key_prefix   = var.s3_key_prefix
  s3_kms_key      = var.s3_kms_key
  sns_topic_name  = var.sns_topic_name
  
  include_global_service_events = var.include_global_service_events
  is_multi_region_trail         = var.is_multi_region_trail
  is_organization_trail         = var.is_organization_trail
  enable_log_file_validation    = var.enable_log_file_validation

  event_selectors           = var.event_selectors
  advanced_event_selectors  = var.advanced_event_selectors
  insight_selector          = var.insight_selector

  lifecycle_rule  = var.lifecycle_rule
  force_destroy   = var.force_destroy
  bucket_policy   = var.bucket_policy

  enable_cloudwatch     = var.enable_cloudwatch
  cw_log_retention      = var.cw_log_retention
  cloudwatch_kms_key_id = var.cloudwatch_kms_key_id
}
```

### `terraform.tfvars.json`
> **_NOTE:_** Add selectors to variables as described in sections below.

```json
{
  "name": "test-trail",
  "tags": {
    "environment": "prod"
  },
  "enable_logging": true,
  "s3_key_prefix": "logs/",
  "s3_kms_key": "arn:aws:kms:us-east-1:319244236588:key/dfed962d-0968-42b4-ad36-7762dac7ca20",
  "sns_topic_name": "arn:aws:sns:us-east-1:319244236588:test-sns-topic",
  "include_global_service_events": true,
  "is_multi_region_trail": false,
  "is_organization_trail": false,
  "insight_selector": false,
  "enable_log_file_validation": false,
  "enable_cloudwatch": true,
  "cw_log_retention": 60,
  "cloudwatch_kms_key_id": "arn:aws:kms:us-east-1:319244236588:key/dfed962d-0968-42b4-ad36-7762dac7ca20"
}
```

Advanced selectors
```json
{
  "advanced_event_selectors": [
    {
      "name": "test-adv-selector",
      "field_selector": [
        {
          "field": "eventCategory",
          "equals": ["Data"]
        },
        {
          "field": "resources.type",
          "equals": ["AWS::S3::Object"]
        },
        {
          "field": "resources.ARN",
          "starts_with": ["arn:aws:s3:::test-luka-290183"]
        }
      ]
    }
  ]
}
```

Basic selectors
```json
{
  "event_selectors": [
    {
      "include_management_events": false,
      "read_write_type": "All",
      "data_resources": [
        {
          "type": "AWS::S3::Object",
          "values": ["arn:aws:s3:::test-luka-290183/"]
        }
      ]
    }
  ]
}
```

### `provider.tf`
```terraform
provider "aws" {
  region = "us-east-1"
  default_tags {
    tags = {
      team : "DataOps",
      purpose : "cloudtrail_trail_test",
      owner : "Luka"
    }
  }
}
```

### `variables.tf`
copy ones from module

### `outputs.tf`
```terraform
output "trail_name" {
  value       = module.cloudtrail.trail_name
  description = "Name of the CloudTrail trail."
}
```
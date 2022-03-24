locals {
  enabled    = module.this.enabled
  bucket_arn = "arn:${data.aws_partition.current.partition}:s3:::${join("", aws_s3_bucket.default.*.id)}"
}

module "logs" {
  source     = "cloudposse/s3-log-storage/aws"
  version    = "0.28.0"
  attributes = ["logs"]
  context    = module.this.context
  lifecycle_configuration_rules = [
    {
      abort_incomplete_multipart_upload_days = 1
      enabled                                = true
      expiration = {
        days = 90
      }
      filter_and = {
        prefix = ""
      }
      id = "logs"
      noncurrent_version_expiration = {
        newer_noncurrent_versions = 2
        noncurrent_days           = 30
      }
      noncurrent_version_transition = []
      transition = [
        {
          days          = 30
          storage_class = "GLACIER"
        },
      ]
    }
  ]
}


module "default_label" {
  source     = "cloudposse/label/null"
  version    = "0.25.0"
  attributes = ["origin"]
  context    = module.this.context
}

resource "aws_s3_bucket" "default" {
  count = local.enabled ? 1 : 0

  #bridgecrew:skip=BC_AWS_S3_1:The bucket used for a public static website. (https://docs.bridgecrew.io/docs/s3_1-acl-read-permissions-everyone)
  #bridgecrew:skip=BC_AWS_S3_14:Skipping `Ensure all data stored in the S3 bucket is securely encrypted at rest` check until bridgecrew will support dynamic blocks (https://github.com/bridgecrewio/checkov/issues/776).
  #bridgecrew:skip=CKV_AWS_52:Skipping `Ensure S3 bucket has MFA delete enabled` due to issue using `mfa_delete` by terraform (https://github.com/hashicorp/terraform-provider-aws/issues/629).

  bucket        = var.hostname
  tags          = module.default_label.tags
  force_destroy = var.force_destroy
}

# S3 acl resource support for AWS provider V4
resource "aws_s3_bucket_acl" "default" {
  bucket = aws_s3_bucket.default[0].id
  acl    = "public-read"
}

# S3 logging resource support for AWS provider v4
resource "aws_s3_bucket_logging" "default" {
  for_each = var.logs_enabled ? toset(["true"]) : toset([])
  bucket   = aws_s3_bucket.default[0].id

  target_bucket = module.logs.bucket_id
  target_prefix = module.logs.prefix
}

# S3 versioning resource support for AWS provider v4
resource "aws_s3_bucket_versioning" "default" {
  bucket = aws_s3_bucket.default[0].id
  versioning_configuration {
    status = var.versioning_enabled ? "Enabled" : "Suspended"
  }
}

# S3 website configuration support for AWS provider v4
resource "aws_s3_bucket_website_configuration" "default" {
  bucket = aws_s3_bucket.default[0].bucket

  index_document {
    suffix = var.index_document
  }

  error_document {
    key = var.error_document
  }
}

# S3 cors configuration support for AWS provider v4
resource "aws_s3_bucket_cors_configuration" "default" {
  bucket = aws_s3_bucket.default[0].bucket

  cors_rule {
    allowed_headers = var.cors_allowed_headers
    allowed_methods = var.cors_allowed_methods
    allowed_origins = var.cors_allowed_origins
    expose_headers  = var.cors_expose_headers
    max_age_seconds = var.cors_max_age_seconds
  }
}

# S3 lifecycle configuration support for AWS provider v4
resource "aws_s3_bucket_lifecycle_configuration" "default" {
  depends_on = [aws_s3_bucket_versioning.default]

  bucket = aws_s3_bucket.default[0].bucket

  rule {
    id = module.default_label.id

    filter {
      prefix = var.prefix
    }

    noncurrent_version_expiration {
      noncurrent_days = var.noncurrent_version_expiration_days
    }

    noncurrent_version_transition {
      noncurrent_days = var.noncurrent_version_transition_days
      storage_class   = "GLACIER"
    }

    status = var.lifecycle_rule_enabled ? "Enabled" : "Disabled"
  }
}

# S3 server side encryption support for AWS provider v4
resource "aws_s3_bucket_server_side_encryption_configuration" "default" {
  for_each = var.encryption_enabled ? toset(["true"]) : toset([])
  bucket   = aws_s3_bucket.default[0].bucket

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

# AWS only supports a single bucket policy on a bucket. You can combine multiple Statements into a single policy, but not attach multiple policies.
# https://github.com/hashicorp/terraform/issues/10543
resource "aws_s3_bucket_policy" "default" {
  count = local.enabled ? 1 : 0

  bucket = aws_s3_bucket.default[0].id
  policy = data.aws_iam_policy_document.default[0].json
}

data "aws_iam_policy_document" "default" {
  count = local.enabled ? 1 : 0

  statement {
    actions = ["s3:GetObject"]

    resources = ["${aws_s3_bucket.default[0].arn}/*"]

    principals {
      type        = "AWS"
      identifiers = ["*"]
    }
  }

  dynamic "statement" {
    for_each = var.allow_ssl_requests_only ? [1] : []

    content {
      sid       = "AllowSSLRequestsOnly"
      effect    = "Deny"
      actions   = ["s3:*"]
      resources = [local.bucket_arn, "${local.bucket_arn}/*"]

      principals {
        identifiers = ["*"]
        type        = "*"
      }

      condition {
        test     = "Bool"
        values   = ["false"]
        variable = "aws:SecureTransport"
      }
    }
  }

  # Support replication ARNs
  dynamic "statement" {
    for_each = flatten(data.aws_iam_policy_document.replication.*.statement)
    content {
      actions       = lookup(statement.value, "actions", null)
      effect        = lookup(statement.value, "effect", null)
      not_actions   = lookup(statement.value, "not_actions", null)
      not_resources = lookup(statement.value, "not_resources", null)
      resources     = lookup(statement.value, "resources", null)
      sid           = lookup(statement.value, "sid", null)

      dynamic "condition" {
        for_each = lookup(statement.value, "condition", [])
        content {
          test     = condition.value.test
          values   = condition.value.values
          variable = condition.value.variable
        }
      }

      dynamic "not_principals" {
        for_each = lookup(statement.value, "not_principals", [])
        content {
          identifiers = not_principals.value.identifiers
          type        = not_principals.value.type
        }
      }

      dynamic "principals" {
        for_each = lookup(statement.value, "principals", [])
        content {
          identifiers = principals.value.identifiers
          type        = principals.value.type
        }
      }
    }
  }

  # Support deployment ARNs
  dynamic "statement" {
    for_each = flatten(data.aws_iam_policy_document.deployment.*.statement)
    content {
      actions       = lookup(statement.value, "actions", null)
      effect        = lookup(statement.value, "effect", null)
      not_actions   = lookup(statement.value, "not_actions", null)
      not_resources = lookup(statement.value, "not_resources", null)
      resources     = lookup(statement.value, "resources", null)
      sid           = lookup(statement.value, "sid", null)

      dynamic "condition" {
        for_each = lookup(statement.value, "condition", [])
        content {
          test     = condition.value.test
          values   = condition.value.values
          variable = condition.value.variable
        }
      }

      dynamic "not_principals" {
        for_each = lookup(statement.value, "not_principals", [])
        content {
          identifiers = not_principals.value.identifiers
          type        = not_principals.value.type
        }
      }

      dynamic "principals" {
        for_each = lookup(statement.value, "principals", [])
        content {
          identifiers = principals.value.identifiers
          type        = principals.value.type
        }
      }
    }
  }
}

data "aws_iam_policy_document" "replication" {
  count = local.enabled ? signum(length(var.replication_source_principal_arns)) : 0

  statement {
    principals {
      type        = "AWS"
      identifiers = var.replication_source_principal_arns
    }

    actions = [
      "s3:GetBucketVersioning",
      "s3:PutBucketVersioning",
      "s3:ReplicateObject",
      "s3:ReplicateDelete"
    ]

    resources = [
      aws_s3_bucket.default[0].arn,
      "${aws_s3_bucket.default[0].arn}/*"
    ]
  }
}

data "aws_iam_policy_document" "deployment" {
  count = local.enabled ? length(keys(var.deployment_arns)) : 0

  statement {
    actions = var.deployment_actions

    resources = flatten([
      formatlist(
        "${aws_s3_bucket.default[0].arn}%s",
        var.deployment_arns[keys(var.deployment_arns)[count.index]]
      ),
      formatlist(
        "${aws_s3_bucket.default[0].arn}%s/*",
        var.deployment_arns[keys(var.deployment_arns)[count.index]]
      )
    ])

    principals {
      type        = "AWS"
      identifiers = [keys(var.deployment_arns)[count.index]]
    }
  }
}

data "aws_partition" "current" {}

module "dns" {
  source  = "cloudposse/route53-alias/aws"
  version = "0.12.0"

  enabled          = local.enabled
  aliases          = compact([signum(length(var.parent_zone_id)) == 1 || signum(length(var.parent_zone_name)) == 1 ? var.hostname : ""])
  parent_zone_id   = var.parent_zone_id
  parent_zone_name = var.parent_zone_name
  target_dns_name  = join("", aws_s3_bucket.default.*.website_domain)
  target_zone_id   = join("", aws_s3_bucket.default.*.hosted_zone_id)

  context = module.this.context
}

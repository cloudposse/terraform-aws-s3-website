locals {
  website_config = {
    redirect_all = [
      {
        redirect_all_requests_to = var.redirect_all_requests_to
      }
    ]
    default = [
      {
        index_document = var.index_document
        error_document = var.error_document
        routing_rules  = var.routing_rules
      }
    ]
  }
}

module "logs" {
  source                   = "git::https://github.com/cloudposse/terraform-aws-s3-log-storage.git?ref=tags/0.5.0"
  name                     = var.name
  stage                    = var.stage
  namespace                = var.namespace
  delimiter                = var.delimiter
  attributes               = compact(concat(var.attributes, ["logs"]))
  standard_transition_days = var.logs_standard_transition_days
  glacier_transition_days  = var.logs_glacier_transition_days
  expiration_days          = var.logs_expiration_days
}

module "default_label" {
  source     = "git::https://github.com/cloudposse/terraform-null-label.git?ref=tags/0.14.1"
  namespace  = var.namespace
  stage      = var.stage
  name       = var.name
  delimiter  = var.delimiter
  attributes = compact(concat(var.attributes, ["origin"]))
  tags       = var.tags
}

resource "aws_s3_bucket" "default" {
  bucket        = var.hostname
  acl           = "public-read"
  tags          = module.default_label.tags
  region        = var.region
  force_destroy = var.force_destroy

  logging {
    target_bucket = module.logs.bucket_id
    target_prefix = module.logs.prefix
  }

  dynamic "website" {
    for_each = local.website_config[var.redirect_all_requests_to == "" ? "default" : "redirect_all"]
    content {
      error_document           = lookup(website.value, "error_document", null)
      index_document           = lookup(website.value, "index_document", null)
      redirect_all_requests_to = lookup(website.value, "redirect_all_requests_to", null)
      routing_rules            = lookup(website.value, "routing_rules", null)
    }
  }

  cors_rule {
    allowed_headers = var.cors_allowed_headers
    allowed_methods = var.cors_allowed_methods
    allowed_origins = var.cors_allowed_origins
    expose_headers  = var.cors_expose_headers
    max_age_seconds = var.cors_max_age_seconds
  }

  versioning {
    enabled = var.versioning_enabled
  }

  lifecycle_rule {
    id      = module.default_label.id
    enabled = var.lifecycle_rule_enabled
    prefix  = var.prefix
    tags    = module.default_label.tags

    noncurrent_version_transition {
      days          = var.noncurrent_version_transition_days
      storage_class = "GLACIER"
    }

    noncurrent_version_expiration {
      days = var.noncurrent_version_expiration_days
    }
  }
}

# AWS only supports a single bucket policy on a bucket. You can combine multiple Statements into a single policy, but not attach multiple policies.
# https://github.com/hashicorp/terraform/issues/10543
resource "aws_s3_bucket_policy" "default" {
  bucket = aws_s3_bucket.default.id
  policy = data.aws_iam_policy_document.default.json
}

data "aws_iam_policy_document" "default" {
  statement {
    actions = ["s3:GetObject"]

    resources = ["${aws_s3_bucket.default.arn}/*"]

    principals {
      type        = "AWS"
      identifiers = ["*"]
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
  count = signum(length(var.replication_source_principal_arns))

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
      aws_s3_bucket.default.arn,
      "${aws_s3_bucket.default.arn}/*"
    ]
  }
}

data "aws_iam_policy_document" "deployment" {
  count = length(keys(var.deployment_arns))

  statement {
    actions = var.deployment_actions

    resources = flatten([
      formatlist(
        "${aws_s3_bucket.default.arn}%s",
        var.deployment_arns[keys(var.deployment_arns)[count.index]]
      ),
      formatlist(
        "${aws_s3_bucket.default.arn}%s/*",
        var.deployment_arns[keys(var.deployment_arns)[count.index]]
      )
    ])

    principals {
      type        = "AWS"
      identifiers = [keys(var.deployment_arns)[count.index]]
    }
  }
}

module "dns" {
  source           = "git::https://github.com/cloudposse/terraform-aws-route53-alias.git?ref=tags/0.3.0"
  aliases          = compact([signum(length(var.parent_zone_id)) == 1 || signum(length(var.parent_zone_name)) == 1 ? var.hostname : ""])
  parent_zone_id   = var.parent_zone_id
  parent_zone_name = var.parent_zone_name
  target_dns_name  = aws_s3_bucket.default.website_domain
  target_zone_id   = aws_s3_bucket.default.hosted_zone_id
}

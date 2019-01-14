locals {
  website_config = {
    redirect_all = [{
      redirect_all_requests_to = "${var.redirect_all_requests_to}"
    }]

    default = [{
      index_document = "${var.index_document}"
      error_document = "${var.error_document}"
      routing_rules  = "${var.routing_rules}"
    }]
  }
}

module "logs" {
  source                   = "git::https://github.com/cloudposse/terraform-aws-s3-log-storage.git?ref=tags/0.2.0"
  name                     = "${var.name}"
  stage                    = "${var.stage}"
  namespace                = "${var.namespace}"
  attributes               = ["${compact(concat(var.attributes, list("logs")))}"]
  standard_transition_days = "${var.logs_standard_transition_days}"
  glacier_transition_days  = "${var.logs_glacier_transition_days}"
  expiration_days          = "${var.logs_expiration_days}"
}

module "default_label" {
  source     = "git::https://github.com/cloudposse/terraform-null-label.git?ref=tags/0.3.3"
  namespace  = "${var.namespace}"
  stage      = "${var.stage}"
  name       = "${var.name}"
  delimiter  = "${var.delimiter}"
  attributes = ["${compact(concat(var.attributes, list("origin")))}"]
  tags       = "${var.tags}"
}

resource "aws_s3_bucket" "default" {
  bucket        = "${var.hostname}"
  acl           = "public-read"
  tags          = "${module.default_label.tags}"
  region        = "${var.region}"
  force_destroy = "${var.force_destroy}"

  logging {
    target_bucket = "${module.logs.bucket_id}"
    target_prefix = "${module.logs.prefix}"
  }

  website = "${local.website_config[var.redirect_all_requests_to == "" ? "default" : "redirect_all"]}"

  cors_rule {
    allowed_headers = "${var.cors_allowed_headers}"
    allowed_methods = "${var.cors_allowed_methods}"
    allowed_origins = ["${var.cors_allowed_origins}"]
    expose_headers  = "${var.cors_expose_headers}"
    max_age_seconds = "${var.cors_max_age_seconds}"
  }

  versioning {
    enabled = "${var.versioning_enabled}"
  }

  lifecycle_rule {
    id      = "${module.default_label.id}"
    enabled = "${var.lifecycle_rule_enabled}"
    prefix  = "${var.prefix}"
    tags    = "${module.default_label.tags}"

    noncurrent_version_transition {
      days          = "${var.noncurrent_version_transition_days}"
      storage_class = "GLACIER"
    }

    noncurrent_version_expiration {
      days = "${var.noncurrent_version_expiration_days}"
    }
  }
}

# AWS only supports a single bucket policy on a bucket. You can combine multiple Statements into a single policy, but not attach multiple policies.
# https://github.com/hashicorp/terraform/issues/10543
resource "aws_s3_bucket_policy" "default" {
  bucket = "${aws_s3_bucket.default.id}"
  policy = "${data.aws_iam_policy_document.default.json}"
}

data "aws_iam_policy_document" "default" {
  statement = [{
    actions = ["s3:GetObject"]

    resources = ["${aws_s3_bucket.default.arn}/*"]

    principals {
      type        = "AWS"
      identifiers = ["*"]
    }
  }]

  # Support replication ARNs
  statement = ["${flatten(data.aws_iam_policy_document.replication.*.statement)}"]

  # Support deployment ARNs
  statement = ["${flatten(data.aws_iam_policy_document.deployment.*.statement)}"]
}

data "aws_iam_policy_document" "replication" {
  count = "${signum(length(var.replication_source_principal_arns))}"

  statement {
    principals {
      type        = "AWS"
      identifiers = ["${var.replication_source_principal_arns}"]
    }

    actions = [
      "s3:GetBucketVersioning",
      "s3:PutBucketVersioning",
      "s3:ReplicateObject",
      "s3:ReplicateDelete",
    ]

    resources = [
      "${aws_s3_bucket.default.arn}",
      "${aws_s3_bucket.default.arn}/*",
    ]
  }
}

data "aws_iam_policy_document" "deployment" {
  count = "${length(keys(var.deployment_arns))}"

  statement {
    actions = ["${var.deployment_actions}"]

    resources = [
      "${formatlist("${aws_s3_bucket.default.arn}%s", var.deployment_arns[element(keys(var.deployment_arns), count.index)])}",
      "${formatlist("${aws_s3_bucket.default.arn}%s/*", var.deployment_arns[element(keys(var.deployment_arns), count.index)])}",
    ]

    principals {
      type        = "AWS"
      identifiers = ["${element(keys(var.deployment_arns), count.index)}"]
    }
  }
}

module "dns" {
  source           = "git::https://github.com/cloudposse/terraform-aws-route53-alias.git?ref=tags/0.2.2"
  aliases          = "${compact(list(signum(length(var.parent_zone_id)) == 1 || signum(length(var.parent_zone_name)) == 1 ? var.hostname : ""))}"
  parent_zone_id   = "${var.parent_zone_id}"
  parent_zone_name = "${var.parent_zone_name}"
  target_dns_name  = "${aws_s3_bucket.default.website_domain}"
  target_zone_id   = "${aws_s3_bucket.default.hosted_zone_id}"
}

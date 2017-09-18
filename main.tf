module "logs" {
  source                   = "git::https://github.com/cloudposse/tf_log_storage.git?ref=0.1.0"
  name                     = "${var.name}"
  stage                    = "${var.stage}"
  namespace                = "${var.namespace}"
  standard_transition_days = "${var.logs_standard_transition_days}"
  glacier_transition_days  = "${var.logs_glacier_transition_days}"
  expiration_days          = "${var.logs_expiration_days}"
}

module "default_label" {
  source     = "git::https://github.com/cloudposse/tf_label.git?ref=tags/0.2.0"
  namespace  = "${var.namespace}"
  stage      = "${var.stage}"
  name       = "${var.name}"
  delimiter  = "${var.delimiter}"
  attributes = ["origin"]
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

  website {
    index_document = "${var.index_document}"
    error_document = "${var.error_document}"
    routing_rules  = "${var.routing_rules}"
  }

  cors_rule {
    allowed_headers = "${var.cors_allowed_headers}"
    allowed_methods = "${var.cors_allowed_methods}"
    allowed_origins = "${var.cors_allowed_origins}"
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

resource "aws_s3_bucket_policy" "default" {
  bucket = "${aws_s3_bucket.default.id}"
  policy = "${data.aws_iam_policy_document.default.json}"
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
}

module "dns" {
  source          = "git::https://github.com/cloudposse/tf_vanity.git?ref=generalize"
  aliases         = "${list(signum(length(var.dns_zone_id)) > 0 ? var.hostname : var.dns_zone_id )}"
  parent_zone_id  = "${var.dns_zone_id}"
  target_dns_name = "${aws_s3_bucket.default.website_domain}"
  target_zone_id  = "${aws_s3_bucket.default.hosted_zone_id}"
}

module "logs" {
  source                   = "git::https://github.com/cloudposse/terraform-aws-s3-log-storage.git?ref=tags/0.1.2"
  name                     = "${var.name}"
  stage                    = "${var.stage}"
  namespace                = "${var.namespace}"
  standard_transition_days = "${var.logs_standard_transition_days}"
  glacier_transition_days  = "${var.logs_glacier_transition_days}"
  expiration_days          = "${var.logs_expiration_days}"
}

module "default_label" {
  source     = "git::https://github.com/cloudposse/terraform-null-label.git?ref=tags/0.2.1"
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

  statement = ["${flatten(data.aws_iam_policy_document.master.*.statement)}"]
}

data "aws_iam_policy_document" "master" {
  count = "${length(var.masters)}"

  statement {
    principals {
      type        = "AWS"
      identifiers = ["${format("arn:aws:iam::%v:root", element(keys(var.masters), count.index))}"]
    }

    actions = [
      "s3:GetBucketVersioning",
      "s3:PutBucketVersioning",
      "s3:ReplicateObject",
      "s3:ReplicateDelete",
    ]

    resources = [
      "${format("arn:aws:s3:::%v",   lookup(var.masters, element(keys(var.masters), count.index)))}",
      "${format("arn:aws:s3:::%v/*", lookup(var.masters, element(keys(var.masters), count.index)))}",
    ]
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

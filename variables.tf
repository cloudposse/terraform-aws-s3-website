variable "name" {}

variable "namespace" {}

variable "stage" {}

variable "attributes" {
  type    = "list"
  default = []
}

variable "tags" {
  type    = "map"
  default = {}
}

variable "delimiter" {
  default = "-"
}

variable "hostname" {}

variable "parent_zone_id" {
  description = "ID of the hosted zone to contain the record"
  default     = ""
}

variable "parent_zone_name" {
  description = "Name of the hosted zone to contain the record"
  default     = ""
}

variable "index_document" {
  default = "index.html"
}

variable "error_document" {
  default = "404.html"
}

variable "routing_rules" {
  default = ""
}

variable "cors_allowed_headers" {
  type    = "list"
  default = ["*"]
}

variable "cors_allowed_methods" {
  type    = "list"
  default = ["GET"]
}

variable "cors_allowed_origins" {
  type    = "list"
  default = ["*"]
}

variable "cors_expose_headers" {
  type    = "list"
  default = ["ETag"]
}

variable "cors_max_age_seconds" {
  default = "3600"
}

variable "logs_standard_transition_days" {
  description = "Number of days to persist in the standard storage tier before moving to the glacier tier"
  default     = "30"
}

variable "logs_glacier_transition_days" {
  description = "Number of days after which to move the data to the glacier storage tier"
  default     = "60"
}

variable "logs_expiration_days" {
  description = "Number of days after which to expunge the objects"
  default     = "90"
}

variable "lifecycle_rule_enabled" {
  default = ""
}

variable "prefix" {
  default = ""
}

variable "noncurrent_version_transition_days" {
  default = "30"
}

variable "noncurrent_version_expiration_days" {
  default = "90"
}

variable "region" {
  default = ""
}

variable "replication_source_principal_arn" {
  type        = "list"
  default     = []
  description = "(Optional) List of principal ARNs to grant replication access from different aws account."
}

variable "versioning_enabled" {
  default = ""
}

variable "force_destroy" {
  default = ""
}

variable "deployment_prefix" {
  description = "(Optional) Wildcard prefix permitted to perform `deployment_actions`"
  default     = "*"
}

variable "deployment_arns" {
  description = "(Optional) List of ARNs to grant `deployment_actions` permissions on this bucket"
  type        = "list"
  default     = []
}

variable "deployment_actions" {
  description = "List of actions to permit deployment ARNs to perform"
  type        = "list"
  default     = ["s3:PutObject", "s3:PutObjectAcl", "s3:GetObject", "s3:DeleteObject", "s3:ListBucket", "s3:ListBucketMultipartUploads", "s3:GetBucketLocation", "s3:AbortMultipartUpload"]
}

variable "deployment_arns_deployment_prefixes" {
  type        = "map"
  default     = {}
  description = "Map of deployments ARNs to S3 prefixes to allow the `deployment_actions` to be executed by the ARNs on the deployment prefixes"
}

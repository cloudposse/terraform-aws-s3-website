variable "name" {
  description = "The Name of the application or solution  (e.g. `bastion` or `portal`)"
}

variable "namespace" {
  description = "Namespace (e.g. `cp` or `cloudposse`)"
}

variable "stage" {
  description = "Stage (e.g. `prod`, `dev`, `staging`)"
}

variable "attributes" {
  type        = "list"
  default     = []
  description = "Additional attributes (e.g. `policy` or `role`)"
}

variable "tags" {
  type        = "map"
  default     = {}
  description = "Additional tags (e.g. `map('BusinessUnit','XYZ')`)"
}

variable "delimiter" {
  type        = "string"
  default     = "-"
  description = "Delimiter to be used between `name`, `namespace`, `stage`, etc."
}

variable "hostname" {
  description = "Name of website bucket in `fqdn` format (e.g. `test.example.com`). IMPORTANT! Do not add trailing dot (`.`)"
}

variable "parent_zone_id" {
  description = "ID of the hosted zone to contain the record"
  default     = ""
}

variable "parent_zone_name" {
  description = "Name of the hosted zone to contain the record"
  default     = ""
}

variable "index_document" {
  default     = "index.html"
  description = "Amazon S3 returns this index document when requests are made to the root domain or any of the subfolders"
}

variable "error_document" {
  default     = "404.html"
  description = "An absolute path to the document to return in case of a 4XX error"
}

variable "routing_rules" {
  default     = ""
  description = "A json array containing routing rules describing redirect behavior and when redirects are applied"
}

variable "cors_allowed_headers" {
  type        = "list"
  default     = ["*"]
  description = "List of allowed headers"
}

variable "cors_allowed_methods" {
  type        = "list"
  default     = ["GET"]
  description = "List of allowed methods (e.g. ` GET, PUT, POST, DELETE, HEAD`) "
}

variable "cors_allowed_origins" {
  type        = "list"
  default     = ["*"]
  description = "List of allowed origins (e.g. ` example.com, test.com`)"
}

variable "cors_expose_headers" {
  type        = "list"
  default     = ["ETag"]
  description = "List of expose header in the response"
}

variable "cors_max_age_seconds" {
  default     = "3600"
  description = "Time in seconds that browser can cache the response"
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
  default     = ""
  description = "Lifecycle rule status (e.g. `true` or `false`)"
}

variable "prefix" {
  default     = ""
  description = "Prefix identifying one or more objects to which the rule applies"
}

variable "noncurrent_version_transition_days" {
  default     = "30"
  description = "Number of days to persist in the standard storage tier before moving to the glacier tier infrequent access tier"
}

variable "noncurrent_version_expiration_days" {
  default     = "90"
  description = "Specifies when noncurrent object versions expire"
}

variable "region" {
  default     = ""
  description = "AWS region this bucket should reside in"
}

variable "versioning_enabled" {
  default     = ""
  description = "State of versioning (e.g. `true` or `false`)"
}

variable "force_destroy" {
  default     = ""
  description = "Delete all objects from the bucket so that the bucket can be destroyed without error (e.g. `true` or `false`)"
}

variable "replication_source_principal_arns" {
  type        = "list"
  default     = []
  description = "(Optional) List of principal ARNs to grant replication access from different AWS accounts"
}

variable "deployment_arns" {
  type        = "map"
  default     = {}
  description = "(Optional) Map of deployment ARNs to lists of S3 path prefixes to grant `deployment_actions` permissions"
}

variable "deployment_actions" {
  type        = "list"
  default     = ["s3:PutObject", "s3:PutObjectAcl", "s3:GetObject", "s3:DeleteObject", "s3:ListBucket", "s3:ListBucketMultipartUploads", "s3:GetBucketLocation", "s3:AbortMultipartUpload"]
  description = "List of actions to permit deployment ARNs to perform"
}

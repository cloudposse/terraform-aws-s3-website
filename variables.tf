variable "name" {}

variable "namespace" {}

variable "stage" {}

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

variable "versioning_enabled" {
  default = ""
}

variable "force_destroy" {
  default = ""
}

variable "deployment_arns" {
  description = "(Optional) List of ARNs permitted to deploy to this bucket (read/write access)"
  type    = "list"
  default = []
}

variable "name" {}

variable "namespace" {}

variable "stage" {}

variable "tags" {
  default = {}
}

variable "delimiter" {
  default = "-"
}

variable "dns_zone_id" {
  description = "(optional) DNS zone to register DNS. Leave blank to disable DNS registration."
  default     = ""
}

variable "index_document" {
  default = "index.html"
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
  default = []
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

variable "error_document" {
  default = "404.html"
}

variable "lifecycle_rule_enabled" {
  default = ""
}

variable "prefix" {
  default = ""
}

variable "noncurrent_version_transition_days" {}

variable "region" {
  default = ""
}

# variable "redirect_all_requests_to" {
#   default = ""
# }

variable "noncurrent_version_expiration_days" {}

variable "versioning_enabled" {
  default = ""
}

variable "force_destroy" {
  default = ""
}

variable "hostname" {
  type        = string
  description = "Name of website bucket in `fqdn` format (e.g. `test.example.com`). IMPORTANT! Do not add trailing dot (`.`)"
}

variable "parent_zone_id" {
  type        = string
  description = "ID of the hosted zone to contain the record"
  default     = ""
}

variable "parent_zone_name" {
  type        = string
  description = "Name of the hosted zone to contain the record"
  default     = ""
}

variable "index_document" {
  type        = string
  default     = "index.html"
  description = "Amazon S3 returns this index document when requests are made to the root domain or any of the subfolders"
}

variable "redirect_all_requests_to" {
  type        = string
  default     = ""
  description = "A hostname to redirect all website requests for this bucket to. If this is set `index_document` will be ignored"
}

variable "error_document" {
  type        = string
  default     = "404.html"
  description = "An absolute path to the document to return in case of a 4XX error"
}

variable "routing_rules" {
  type        = string
  default     = ""
  description = "A json array containing routing rules describing redirect behavior and when redirects are applied"
}

variable "cors_rules" {
  description = "Cross-Origin Resource Sharing rules"
  type = list(object({
    allowed_headers = list(string)
    allowed_methods = list(string)
    allowed_origins = list(string)
    expose_headers  = list(string)
    max_age_seconds = number
  }))
  default = [{
    allowed_headers = ["*"]
    allowed_methods = ["GET"]
    allowed_origins = ["*"]
    expose_headers  = ["ETag"]
    max_age_seconds = 3600
    }
  ]
}

variable "logs_enabled" {
  type        = bool
  description = "Enable logs for s3 bucket"
  default     = true
}

variable "logs_standard_transition_days" {
  type        = number
  description = "Number of days to persist in the standard storage tier before moving to the glacier tier"
  default     = 30
}

variable "logs_glacier_transition_days" {
  type        = number
  description = "Number of days after which to move the data to the glacier storage tier"
  default     = 60
}

variable "logs_expiration_days" {
  type        = number
  description = "Number of days after which to expunge the objects"
  default     = 90
}

variable "logs_object_versioning_enabled" {
  description = "Enable object versioning on the logs bucket"
  type        = bool
  default     = false
}

variable "lifecycle_rule_enabled" {
  type        = bool
  default     = false
  description = "Enable or disable lifecycle rule"
}

variable "prefix" {
  type        = string
  default     = ""
  description = "Prefix identifying one or more objects to which the rule applies"
}

variable "noncurrent_version_transition_days" {
  type        = number
  default     = 30
  description = "Number of days to persist in the standard storage tier before moving to the glacier tier infrequent access tier"
}

variable "noncurrent_version_expiration_days" {
  type        = number
  default     = 90
  description = "Specifies when noncurrent object versions expire"
}

variable "versioning_enabled" {
  type        = bool
  default     = true
  description = "Enable or disable versioning"
}

variable "force_destroy" {
  type        = bool
  default     = false
  description = "Delete all objects from the bucket so that the bucket can be destroyed without error (e.g. `true` or `false`)"
}

variable "replication_source_principal_arns" {
  type        = list(string)
  default     = []
  description = "(Optional) List of principal ARNs to grant replication access from different AWS accounts"
}

variable "deployment_arns" {
  type        = map(any)
  default     = {}
  description = "(Optional) Map of deployment ARNs to lists of S3 path prefixes to grant `deployment_actions` permissions"
}

variable "deployment_actions" {
  type        = list(string)
  default     = ["s3:PutObject", "s3:PutObjectAcl", "s3:GetObject", "s3:DeleteObject", "s3:ListBucket", "s3:ListBucketMultipartUploads", "s3:GetBucketLocation", "s3:AbortMultipartUpload"]
  description = "List of actions to permit deployment ARNs to perform"
}

variable "encryption_enabled" {
  type        = bool
  default     = false
  description = "When set to 'true' the resource will have AES256 encryption enabled by default"
}

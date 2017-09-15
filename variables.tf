variable "name" {}

variable "namespage" {}

variable "stage" {}

variable "tags" {
  default = {}
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

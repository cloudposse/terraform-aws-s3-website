variable "region" {
  type        = string
  description = "AWS region"
}

variable "hostname" {
  type        = string
  description = "Name of website bucket in `fqdn` format (e.g. `test.example.com`). IMPORTANT! Do not add trailing dot (`.`)"
}

variable "parent_zone_name" {
  type        = string
  description = "Name of the hosted zone to contain the record"
}

variable "force_destroy" {
  type        = bool
  description = "Delete all objects from the bucket so that the bucket can be destroyed without error (e.g. `true` or `false`)"
}

variable "encryption_enabled" {
  type        = bool
  default     = false
  description = "When set to 'true' the resource will have AES256 encryption enabled by default"
}

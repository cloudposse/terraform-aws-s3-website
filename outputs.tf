output "hostname" {
  value       = var.hostname
  description = "Bucket hostname"
}

output "s3_bucket_name" {
  value       = join("", aws_s3_bucket.default[*].id)
  description = "DNS record of the website bucket"
}

output "s3_bucket_domain_name" {
  value       = join("", aws_s3_bucket.default[*].bucket_domain_name)
  description = "Name of the website bucket"
}

output "s3_bucket_arn" {
  value       = join("", aws_s3_bucket.default[*].arn)
  description = "ARN identifier of the website bucket"
}

output "s3_bucket_website_endpoint" {
  value       = join("", aws_s3_bucket.default[*].website_endpoint)
  description = "The website endpoint URL"
}

output "s3_bucket_website_domain" {
  value       = join("", aws_s3_bucket.default[*].website_domain)
  description = "The domain of the website endpoint"
}

output "s3_bucket_hosted_zone_id" {
  value       = join("", aws_s3_bucket.default[*].hosted_zone_id)
  description = "The Route 53 Hosted Zone ID for this bucket's region"
}

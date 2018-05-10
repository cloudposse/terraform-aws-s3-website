output "hostname" {
  value = "${var.hostname}"
}

output "s3_bucket_name" {
  value = "${aws_s3_bucket.default.id}"
}

output "s3_bucket_domain_name" {
  value = "${aws_s3_bucket.default.bucket_domain_name}"
}

output "s3_bucket_arn" {
  value = "${aws_s3_bucket.default.arn}"
}

output "s3_bucket_website_endpoint" {
  value = "${aws_s3_bucket.default.website_endpoint}"
}

output "s3_bucket_website_domain" {
  value = "${aws_s3_bucket.default.website_domain}"
}

output "s3_bucket_hosted_zone_id" {
  value = "${aws_s3_bucket.default.hosted_zone_id}"
}

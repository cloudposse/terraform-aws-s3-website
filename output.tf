output "s3_bucket_name" {
  value = "${aws_s3_bucket.default.id}"
}

output "s3_bucket_bucket_domain_name" {
  value = "${aws_s3_bucket.default.bucket_domain_name}"
}

output "hostname" {
  value = "${var.hostname}"
}

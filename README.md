# terraform-aws-s3-website

Terraform module for creating S3 backed Websites

## Further Reading

* http://docs.aws.amazon.com/AmazonS3/latest/dev/website-hosting-custom-domain-walkthrough.html


## Usage

#### Create s3 website bucket

```hcl
module "website" {
  source      = "git::https://github.com/cloudposse/terraform-aws-s3-website.git?ref=master"
  namespace   = "${var.namespace}"
  stage       = "${var.stage}"
  name        = "${var.name}"
  hostname    = "${var.hostname}"
}
```

#### Create S3 Website Bucket with Route53 DNS

* Required one of the `parent_zone_id` or `parent_zone_name`

```hcl
module "website_with_cname" {
  source         = "git::https://github.com/cloudposse/terraform-aws-s3-website.git?ref=master"
  namespace      = "${var.namespace}"
  stage          = "${var.stage}"
  name           = "${var.name}"
  hostname       = "${var.hostname}"
  parent_zone_id = "${var.parent_zone_id}"
}
```


## Variables

|  Name                               |  Default       |  Description                                                                                                    | Required |
|:------------------------------------|:--------------:|:----------------------------------------------------------------------------------------------------------------|:--------:|
| `namespace`                         | ``             | Namespace (e.g. `cp` or `cloudposse`)                                                                           | Yes      |
| `stage`                             | ``             | Stage (e.g. `prod`, `dev`, `staging`)                                                                           | Yes      |
| `name`                              | ``             | Name  (e.g. `bastion` or `db`)                                                                                  | Yes      |
| `attributes`                        | `[]`           | Additional attributes (e.g. `policy` or `role`)                                                                 | No       |
| `tags`                              | `{}`           | Additional tags  (e.g. `map("BusinessUnit","XYZ")`                                                              | No       |
| `delimiter`                         | `-`            | Delimiter to be used between `name`, `namespace`, `stage`, `arguments`, etc.                                    | No       |
| `hostname`                          | `[]`           | Name of website bucket in `fqdn` format (e.g. `test.example.com`). IMPORTANT! Do not add trailing dot (`.`)     | Yes      |
| `parent_zone_id`                    | ``             | ID of the hosted zone to contain the record or specify `parent_zone_name` instead                               | No       |
| `parent_zone_name`                  | ``             | Name of the hosted zone to contain the record or specify `parent_zone_id` instead                               | No       |
| `error_document`                    | `404.html`     | An absolute path to the document to return in case of a 4XX error                                               | No       |
| `index_document`                    | `index.html`   | Amazon S3 returns this index document when requests are made to the root domain or any of the subfolders        | No       |
| `force_destroy`                     | ``             | Delete all objects from the bucket so that the bucket can be destroyed without error (e.g. `true` or `false`)   | No       |
| `lifecycle_rule_enabled`            | ``             | Lifecycle rule status (e.g. `true` or `false`)                                                                  | No       |
| `noncurrent_version_transition_days`| `30`           | Number of days to persist in the standard storage tier before moving to the glacier tier infrequent access tier | No       |
| `noncurrent_version_expiration_days`| `90`           | Specifies when noncurrent object versions expire                                                                | No       |
| `cors_allowed_headers`              | `["*"]`        | List of allowed headers                                                                                         | No       |
| `cors_allowed_methods`              | `["GET"]`      | List of allowed methods (e.g. ` GET, PUT, POST, DELETE, HEAD`)                                                  | No       |
| `cors_allowed_origins`              | `["*"]`        | List of allowed origins (e.g. ` example.com, test.com`)                                                         | No       |
| `cors_max_age_seconds`              | `3600`         | Time in seconds that browser can cache the response                                                             | No       |
| `cors_expose_headers`               | `["ETag"]`     | List of expose header in the response                                                                           | No       |
| `prefix`                            | ``             | Prefix identifying one or more objects to which the rule applies                                                | No       |
| `region`                            | ``             | AWS region this bucket should reside in                                                                         | No       |
| `routing_rules`                     | ``             | A json array containing routing rules describing redirect behavior and when redirects are applied               | No       |
| `versioning_enabled`                | ``             | State of versioning (e.g. `true` or `false`)                                                                    | No       |
| `logs_standard_transition_days`     | `30`           | Number of days to persist in the standard storage tier before moving to the glacier tier                        | No       |
| `logs_glacier_transition_days`      | `60`           | Number of days after which to move the data to the glacier storage tier                                         | No       |
| `logs_expiration_days`              | `90`           | Number of days after which to expunge the objects                                                               | No       |
| `replication_source_principal_arn`  | `[]`           | List of principal ARNs to grant replication access from different AWS accounts                                  | No       |
| `deployment_arns`                   | `{}`           | Map of deployment ARNs to S3 prefixes to grant `deployment_actions` permissions                                 | No       |
| `deployment_actions`                | read/write/ls  | List of actions to permit deployment ARNs to perform                                                            | No       |


## Outputs

| Name                           | Description                                                 |
|:------------------------------ |:------------------------------------------------------------|
| `hostname`                     | Assigned DNS-record to the DNS-record of website bucket     |
| `s3_bucket_domain_name`        | DNS-record of website bucket                                |
| `s3_bucket_name`               | Name of of website bucket                                   |


## License

Apache 2 License. See [`LICENSE`](LICENSE) for full details.

# tf_s3_website

Terraform Module for Creating S3 backed Websites

## Further Reading

* http://docs.aws.amazon.com/AmazonS3/latest/dev/website-hosting-custom-domain-walkthrough.html

## Usage

```terraform
module "website" {
  source      = "git::https://github.com/cloudposse/tf_s3_website.git?ref=master"
  namespace   = "${var.namespace}"
  stage       = "${var.stage}"
  name        = "${var.name}"
  hostname    = "${var.hostname}"
  dns_zone_id = "${var.dns_zone_id}"
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
| `dns_zone_id`                       | ``             | ID of the hosted zone to contain the record                                                                     | Yes      |
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


## Outputs

| Name                           | Description                                                 |
|:------------------------------ |:------------------------------------------------------------|
| `hostname`                     | Assigned DNS-record to the DNS-record of website bucket     |
| `s3_bucket_domain_name`        | DNS-record of website bucket                                |
| `s3_bucket_name`               | Name of of website bucket                                   |

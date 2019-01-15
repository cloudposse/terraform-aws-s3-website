## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| attributes | Additional attributes (e.g. `policy` or `role`) | list | `<list>` | no |
| cors_allowed_headers | List of allowed headers | list | `<list>` | no |
| cors_allowed_methods | List of allowed methods (e.g. ` GET, PUT, POST, DELETE, HEAD`) | list | `<list>` | no |
| cors_allowed_origins | List of allowed origins (e.g. ` example.com, test.com`) | list | `<list>` | no |
| cors_expose_headers | List of expose header in the response | list | `<list>` | no |
| cors_max_age_seconds | Time in seconds that browser can cache the response | string | `3600` | no |
| delimiter | Delimiter to be used between `name`, `namespace`, `stage`, etc. | string | `-` | no |
| deployment_actions | List of actions to permit deployment ARNs to perform | list | `<list>` | no |
| deployment_arns | (Optional) Map of deployment ARNs to lists of S3 path prefixes to grant `deployment_actions` permissions | map | `<map>` | no |
| error_document | An absolute path to the document to return in case of a 4XX error | string | `404.html` | no |
| force_destroy | Delete all objects from the bucket so that the bucket can be destroyed without error (e.g. `true` or `false`) | string | `` | no |
| hostname | Name of website bucket in `fqdn` format (e.g. `test.example.com`). IMPORTANT! Do not add trailing dot (`.`) | string | - | yes |
| index_document | Amazon S3 returns this index document when requests are made to the root domain or any of the subfolders | string | `index.html` | no |
| lifecycle_rule_enabled | Lifecycle rule status (e.g. `true` or `false`) | string | `` | no |
| logs_expiration_days | Number of days after which to expunge the objects | string | `90` | no |
| logs_glacier_transition_days | Number of days after which to move the data to the glacier storage tier | string | `60` | no |
| logs_standard_transition_days | Number of days to persist in the standard storage tier before moving to the glacier tier | string | `30` | no |
| name | The Name of the application or solution  (e.g. `bastion` or `portal`) | string | - | yes |
| namespace | Namespace (e.g. `cp` or `cloudposse`) | string | - | yes |
| noncurrent_version_expiration_days | Specifies when noncurrent object versions expire | string | `90` | no |
| noncurrent_version_transition_days | Number of days to persist in the standard storage tier before moving to the glacier tier infrequent access tier | string | `30` | no |
| parent_zone_id | ID of the hosted zone to contain the record | string | `` | no |
| parent_zone_name | Name of the hosted zone to contain the record | string | `` | no |
| prefix | Prefix identifying one or more objects to which the rule applies | string | `` | no |
| redirect_all_requests_to | A hostname to redirect all website requests for this bucket to. If this is set `index_document` will be ignored. | string | `` | no |
| region | AWS region this bucket should reside in | string | `` | no |
| replication_source_principal_arns | (Optional) List of principal ARNs to grant replication access from different AWS accounts | list | `<list>` | no |
| routing_rules | A json array containing routing rules describing redirect behavior and when redirects are applied | string | `` | no |
| stage | Stage (e.g. `prod`, `dev`, `staging`) | string | - | yes |
| tags | Additional tags (e.g. `map('BusinessUnit','XYZ')`) | map | `<map>` | no |
| versioning_enabled | State of versioning (e.g. `true` or `false`) | string | `` | no |

## Outputs

| Name | Description |
|------|-------------|
| hostname | Bucket hostname |
| s3_bucket_arn | Name of of website bucket |
| s3_bucket_domain_name | Name of of website bucket |
| s3_bucket_hosted_zone_id | The Route 53 Hosted Zone ID for this bucket's region |
| s3_bucket_name | DNS record of website bucket |
| s3_bucket_website_domain | The domain of the website endpoint |
| s3_bucket_website_endpoint | The website endpoint URL |


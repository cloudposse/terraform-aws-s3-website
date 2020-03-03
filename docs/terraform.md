## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| attributes | Additional attributes (e.g. `policy` or `role`) | list(string) | `<list>` | no |
| cors_allowed_headers | List of allowed headers | list(string) | `<list>` | no |
| cors_allowed_methods | List of allowed methods (e.g. GET, PUT, POST, DELETE, HEAD) | list(string) | `<list>` | no |
| cors_allowed_origins | List of allowed origins (e.g. example.com, test.com) | list(string) | `<list>` | no |
| cors_expose_headers | List of expose header in the response | list(string) | `<list>` | no |
| cors_max_age_seconds | Time in seconds that browser can cache the response | number | `3600` | no |
| delimiter | Delimiter to be used between `name`, `namespace`, `stage`, etc. | string | `-` | no |
| deployment_actions | List of actions to permit deployment ARNs to perform | list(string) | `<list>` | no |
| deployment_arns | (Optional) Map of deployment ARNs to lists of S3 path prefixes to grant `deployment_actions` permissions | map(any) | `<map>` | no |
| error_document | An absolute path to the document to return in case of a 4XX error | string | `404.html` | no |
| force_destroy | Delete all objects from the bucket so that the bucket can be destroyed without error (e.g. `true` or `false`) | bool | `false` | no |
| hostname | Name of website bucket in `fqdn` format (e.g. `test.example.com`). IMPORTANT! Do not add trailing dot (`.`) | string | - | yes |
| index_document | Amazon S3 returns this index document when requests are made to the root domain or any of the subfolders | string | `index.html` | no |
| lifecycle_rule_enabled | Enable or disable lifecycle rule | bool | `false` | no |
| logs_expiration_days | Number of days after which to expunge the objects | number | `90` | no |
| logs_glacier_transition_days | Number of days after which to move the data to the glacier storage tier | number | `60` | no |
| logs_standard_transition_days | Number of days to persist in the standard storage tier before moving to the glacier tier | number | `30` | no |
| name | The Name of the application or solution  (e.g. `bastion` or `portal`) | string | - | yes |
| namespace | Namespace (e.g. `eg` or `cp`) | string | `` | no |
| noncurrent_version_expiration_days | Specifies when noncurrent object versions expire | number | `90` | no |
| noncurrent_version_transition_days | Number of days to persist in the standard storage tier before moving to the glacier tier infrequent access tier | number | `30` | no |
| parent_zone_id | ID of the hosted zone to contain the record | string | `` | no |
| parent_zone_name | Name of the hosted zone to contain the record | string | `` | no |
| prefix | Prefix identifying one or more objects to which the rule applies | string | `` | no |
| redirect_all_requests_to | A hostname to redirect all website requests for this bucket to. If this is set `index_document` will be ignored | string | `` | no |
| region | AWS region this bucket should reside in | string | `` | no |
| replication_source_principal_arns | (Optional) List of principal ARNs to grant replication access from different AWS accounts | list(string) | `<list>` | no |
| routing_rules | A json array containing routing rules describing redirect behavior and when redirects are applied | string | `` | no |
| stage | Stage (e.g. `prod`, `dev`, `staging`) | string | `` | no |
| tags | Additional tags (e.g. `map('BusinessUnit','XYZ')`) | map(string) | `<map>` | no |
| versioning_enabled | Enable or disable versioning | bool | `false` | no |

## Outputs

| Name | Description |
|------|-------------|
| hostname | Bucket hostname |
| s3_bucket_arn | ARN identifier of website bucket |
| s3_bucket_domain_name | Name of website bucket |
| s3_bucket_hosted_zone_id | The Route 53 Hosted Zone ID for this bucket's region |
| s3_bucket_name | DNS record of website bucket |
| s3_bucket_website_domain | The domain of the website endpoint |
| s3_bucket_website_endpoint | The website endpoint URL |


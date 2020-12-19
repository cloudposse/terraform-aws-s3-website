<!-- markdownlint-disable -->
## Requirements

| Name | Version |
|------|---------|
| terraform | >= 0.12.26 |
| aws | >= 2.0 |
| local | >= 1.2 |
| null | >= 2.0 |

## Providers

| Name | Version |
|------|---------|
| aws | >= 2.0 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| additional\_tag\_map | Additional tags for appending to tags\_as\_list\_of\_maps. Not added to `tags`. | `map(string)` | `{}` | no |
| attributes | Additional attributes (e.g. `1`) | `list(string)` | `[]` | no |
| context | Single object for setting entire context at once.<br>See description of individual variables for details.<br>Leave string and numeric variables as `null` to use default value.<br>Individual variable settings (non-null) override settings in context object,<br>except for attributes, tags, and additional\_tag\_map, which are merged. | <pre>object({<br>    enabled             = bool<br>    namespace           = string<br>    environment         = string<br>    stage               = string<br>    name                = string<br>    delimiter           = string<br>    attributes          = list(string)<br>    tags                = map(string)<br>    additional_tag_map  = map(string)<br>    regex_replace_chars = string<br>    label_order         = list(string)<br>    id_length_limit     = number<br>  })</pre> | <pre>{<br>  "additional_tag_map": {},<br>  "attributes": [],<br>  "delimiter": null,<br>  "enabled": true,<br>  "environment": null,<br>  "id_length_limit": null,<br>  "label_order": [],<br>  "name": null,<br>  "namespace": null,<br>  "regex_replace_chars": null,<br>  "stage": null,<br>  "tags": {}<br>}</pre> | no |
| cors\_allowed\_headers | List of allowed headers | `list(string)` | <pre>[<br>  "*"<br>]</pre> | no |
| cors\_allowed\_methods | List of allowed methods (e.g. GET, PUT, POST, DELETE, HEAD) | `list(string)` | <pre>[<br>  "GET"<br>]</pre> | no |
| cors\_allowed\_origins | List of allowed origins (e.g. example.com, test.com) | `list(string)` | <pre>[<br>  "*"<br>]</pre> | no |
| cors\_expose\_headers | List of expose header in the response | `list(string)` | <pre>[<br>  "ETag"<br>]</pre> | no |
| cors\_max\_age\_seconds | Time in seconds that browser can cache the response | `number` | `3600` | no |
| delimiter | Delimiter to be used between `namespace`, `environment`, `stage`, `name` and `attributes`.<br>Defaults to `-` (hyphen). Set to `""` to use no delimiter at all. | `string` | `null` | no |
| deployment\_actions | List of actions to permit deployment ARNs to perform | `list(string)` | <pre>[<br>  "s3:PutObject",<br>  "s3:PutObjectAcl",<br>  "s3:GetObject",<br>  "s3:DeleteObject",<br>  "s3:ListBucket",<br>  "s3:ListBucketMultipartUploads",<br>  "s3:GetBucketLocation",<br>  "s3:AbortMultipartUpload"<br>]</pre> | no |
| deployment\_arns | (Optional) Map of deployment ARNs to lists of S3 path prefixes to grant `deployment_actions` permissions | `map(any)` | `{}` | no |
| enabled | Set to false to prevent the module from creating any resources | `bool` | `null` | no |
| environment | Environment, e.g. 'uw2', 'us-west-2', OR 'prod', 'staging', 'dev', 'UAT' | `string` | `null` | no |
| error\_document | An absolute path to the document to return in case of a 4XX error | `string` | `"404.html"` | no |
| force\_destroy | Delete all objects from the bucket so that the bucket can be destroyed without error (e.g. `true` or `false`) | `bool` | `false` | no |
| hostname | Name of website bucket in `fqdn` format (e.g. `test.example.com`). IMPORTANT! Do not add trailing dot (`.`) | `string` | n/a | yes |
| id\_length\_limit | Limit `id` to this many characters.<br>Set to `0` for unlimited length.<br>Set to `null` for default, which is `0`.<br>Does not affect `id_full`. | `number` | `null` | no |
| index\_document | Amazon S3 returns this index document when requests are made to the root domain or any of the subfolders | `string` | `"index.html"` | no |
| label\_order | The naming order of the id output and Name tag.<br>Defaults to ["namespace", "environment", "stage", "name", "attributes"].<br>You can omit any of the 5 elements, but at least one must be present. | `list(string)` | `null` | no |
| lifecycle\_rule\_enabled | Enable or disable lifecycle rule | `bool` | `false` | no |
| logs\_expiration\_days | Number of days after which to expunge the objects | `number` | `90` | no |
| logs\_glacier\_transition\_days | Number of days after which to move the data to the glacier storage tier | `number` | `60` | no |
| logs\_standard\_transition\_days | Number of days to persist in the standard storage tier before moving to the glacier tier | `number` | `30` | no |
| name | Solution name, e.g. 'app' or 'jenkins' | `string` | `null` | no |
| namespace | Namespace, which could be your organization name or abbreviation, e.g. 'eg' or 'cp' | `string` | `null` | no |
| noncurrent\_version\_expiration\_days | Specifies when noncurrent object versions expire | `number` | `90` | no |
| noncurrent\_version\_transition\_days | Number of days to persist in the standard storage tier before moving to the glacier tier infrequent access tier | `number` | `30` | no |
| parent\_zone\_id | ID of the hosted zone to contain the record | `string` | `""` | no |
| parent\_zone\_name | Name of the hosted zone to contain the record | `string` | `""` | no |
| prefix | Prefix identifying one or more objects to which the rule applies | `string` | `""` | no |
| redirect\_all\_requests\_to | A hostname to redirect all website requests for this bucket to. If this is set `index_document` will be ignored | `string` | `""` | no |
| regex\_replace\_chars | Regex to replace chars with empty string in `namespace`, `environment`, `stage` and `name`.<br>If not set, `"/[^a-zA-Z0-9-]/"` is used to remove all characters other than hyphens, letters and digits. | `string` | `null` | no |
| replication\_source\_principal\_arns | (Optional) List of principal ARNs to grant replication access from different AWS accounts | `list(string)` | `[]` | no |
| routing\_rules | A json array containing routing rules describing redirect behavior and when redirects are applied | `string` | `""` | no |
| stage | Stage, e.g. 'prod', 'staging', 'dev', OR 'source', 'build', 'test', 'deploy', 'release' | `string` | `null` | no |
| tags | Additional tags (e.g. `map('BusinessUnit','XYZ')` | `map(string)` | `{}` | no |
| versioning\_enabled | Enable or disable versioning | `bool` | `false` | no |

## Outputs

| Name | Description |
|------|-------------|
| hostname | Bucket hostname |
| s3\_bucket\_arn | ARN identifier of website bucket |
| s3\_bucket\_domain\_name | Name of website bucket |
| s3\_bucket\_hosted\_zone\_id | The Route 53 Hosted Zone ID for this bucket's region |
| s3\_bucket\_name | DNS record of website bucket |
| s3\_bucket\_website\_domain | The domain of the website endpoint |
| s3\_bucket\_website\_endpoint | The website endpoint URL |

<!-- markdownlint-restore -->

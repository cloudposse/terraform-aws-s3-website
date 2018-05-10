# terraform-aws-s3-website [![Build Status](https://travis-ci.org/cloudposse/terraform-aws-s3-website.svg?branch=master)](https://travis-ci.org/cloudposse/terraform-aws-s3-website)

Terraform module to provision S3-backed Websites


## Further Reading

* http://docs.aws.amazon.com/AmazonS3/latest/dev/website-hosting-custom-domain-walkthrough.html


## Usage

#### Create s3 website bucket

```hcl
module "website" {
  source    = "git::https://github.com/cloudposse/terraform-aws-s3-website.git?ref=master"
  namespace = "cp"
  stage     = "prod"
  name      = "app"
  hostname  = "docs.prod.cloudposse.org"

  deployment_arns = {
    "arn:aws:s3:::principal1" = ["/prefix1", "/prefix2"]
    "arn:aws:s3:::principal2" = [""]
  }
}
```


#### Create S3 website bucket with Route53 DNS

* Required one of the `parent_zone_id` or `parent_zone_name`

```hcl
module "website_with_cname" {
  source         = "git::https://github.com/cloudposse/terraform-aws-s3-website.git?ref=master"
  namespace      = "cp"
  stage          = "prod"
  name           = "app"
  hostname       = "docs.prod.cloudposse.org"
  parent_zone_id = "XXXXXXXXXXXX"
}
```


## Variables

|  Name                               |  Default       |  Description                                                                                                    | Required |
|:------------------------------------|:--------------:|:----------------------------------------------------------------------------------------------------------------|:--------:|
| `namespace`                         | ``             | Namespace (e.g. `cp` or `cloudposse`)                                                                           | Yes      |
| `stage`                             | ``             | Stage (e.g. `prod`, `dev`, `staging`)                                                                           | Yes      |
| `name`                              | ``             | Name  (e.g. `app`)                                                                                              | Yes      |
| `attributes`                        | `[]`           | Additional attributes (e.g. `1`)                                                                                | No       |
| `tags`                              | `{}`           | Additional tags  (e.g. `map("BusinessUnit","XYZ")`                                                              | No       |
| `delimiter`                         | `-`            | Delimiter to be used between `namespace`, `stage`, `name` and `attributes`                                      | No       |
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
| `replication_source_principal_arns` | `[]`           | List of principal ARNs to grant replication access from different AWS accounts                                  | No       |
| `deployment_arns`                   | `{}`           | Map of deployment ARNs to lists of S3 path prefixes to grant `deployment_actions` permissions                   | No       |
| `deployment_actions`                | read/write/ls  | List of actions to permit deployment ARNs to perform                                                            | No       |


## Outputs

| Name                           | Description                                                 |
|:------------------------------ |:------------------------------------------------------------|
| `hostname`                     | Bucket hostname                                             |
| `s3_bucket_domain_name`        | DNS record of website bucket                                |
| `s3_bucket_name`               | Name of of website bucket                                   |
| `s3_bucket_arn`                | Name of of website bucket                                   |
| `s3_bucket_website_endpoint`   | The website endpoint URL                                    |
| `s3_bucket_website_domain`     | The domain of the website endpoint                          |
| `s3_bucket_hosted_zone_id`     | The Route 53 Hosted Zone ID for this bucket's region        |


## Help

**Got a question?**

File a GitHub [issue](https://github.com/cloudposse/terraform-aws-s3-website/issues), send us an [email](mailto:hello@cloudposse.com) or reach out to us on [Gitter](https://gitter.im/cloudposse/).


## Contributing

### Bug Reports & Feature Requests

Please use the [issue tracker](https://github.com/cloudposse/terraform-aws-s3-website/issues) to report any bugs or file feature requests.

### Developing

If you are interested in being a contributor and want to get involved in developing `terraform-aws-s3-website`, we would love to hear from you! Shoot us an [email](mailto:hello@cloudposse.com).

In general, PRs are welcome. We follow the typical "fork-and-pull" Git workflow.

 1. **Fork** the repo on GitHub
 2. **Clone** the project to your own machine
 3. **Commit** changes to your own branch
 4. **Push** your work back up to your fork
 5. Submit a **Pull request** so that we can review your changes

**NOTE:** Be sure to merge the latest from "upstream" before making a pull request!


## License

[APACHE 2.0](LICENSE) © 2017-2018 [Cloud Posse, LLC](https://cloudposse.com)

See [LICENSE](LICENSE) for full details.

    Licensed to the Apache Software Foundation (ASF) under one
    or more contributor license agreements.  See the NOTICE file
    distributed with this work for additional information
    regarding copyright ownership.  The ASF licenses this file
    to you under the Apache License, Version 2.0 (the
    "License"); you may not use this file except in compliance
    with the License.  You may obtain a copy of the License at

      http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing,
    software distributed under the License is distributed on an
    "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
    KIND, either express or implied.  See the License for the
    specific language governing permissions and limitations
    under the License.


## About

`terraform-aws-s3-website` is maintained and funded by [Cloud Posse, LLC][website].

![Cloud Posse](https://cloudposse.com/logo-300x69.png)


Like it? Please let us know at <hello@cloudposse.com>

We love [Open Source Software](https://github.com/cloudposse/)!

See [our other projects][community]
or [hire us][hire] to help build your next cloud platform.

  [website]: https://cloudposse.com/
  [community]: https://github.com/cloudposse/
  [hire]: https://cloudposse.com/contact/


## Contributors

| [![Erik Osterman][erik_img]][erik_web]<br/>[Erik Osterman][erik_web] | [![Andriy Knysh][andriy_img]][andriy_web]<br/>[Andriy Knysh][andriy_web] |[![Igor Rodionov][igor_img]][igor_web]<br/>[Igor Rodionov][igor_img]
|-------------------------------------------------------|------------------------------------------------------------------|------------------------------------------------------------------|

[erik_img]: http://s.gravatar.com/avatar/88c480d4f73b813904e00a5695a454cb?s=144
[erik_web]: https://github.com/osterman/
[andriy_img]: https://avatars0.githubusercontent.com/u/7356997?v=4&u=ed9ce1c9151d552d985bdf5546772e14ef7ab617&s=144
[andriy_web]: https://github.com/aknysh/
[igor_img]: http://s.gravatar.com/avatar/bc70834d32ed4517568a1feb0b9be7e2?s=144
[igor_web]: https://github.com/goruha/

provider "aws" {
  region = var.region
}

module "s3_website" {
  source           = "../../"
  namespace        = var.namespace
  stage            = var.stage
  name             = var.name
  hostname         = var.hostname
  parent_zone_name = var.parent_zone_name
  force_destroy    = var.force_destroy
}

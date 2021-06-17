provider "aws" {
  region = var.region
}

module "s3_website" {
  source             = "../../"
  hostname           = var.hostname
  parent_zone_name   = var.parent_zone_name
  force_destroy      = var.force_destroy
  encryption_enabled = var.encryption_enabled

  context = module.this.context
}

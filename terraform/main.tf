locals {
  name_prefix = var.project_name
}

module "cicd" {
  source        = "./modules/cicd"
  name_prefix   = local.name_prefix
  project_id    = var.project_id
  region        = var.region
  environment   = var.environment
  initial_image = var.initial_image
}

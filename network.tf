module "vpc" {
  source = "./modules/vpc"
  for_each = var.vpcs

  project_id = var.project_id
  region     = var.region
  vpc_name   = each.key
  subnets    = each.value.subnets
}

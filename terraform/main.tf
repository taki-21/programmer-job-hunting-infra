module "network" {
  source = "./network"
  app_name = var.app_name
}

module "acm" {
  source = "./acm"
  domain = var.domain
}

module "elb" {
  source = "./elb"
  app_name = var.app_name

  vpc_id   = module.network.vpc_id
  public_subnet_ids = module.network.public_subnet_ids
  acm_id            = module.acm.acm_id
  domain            = var.domain
}

module "ecr" {
  source = "./ecr"
}

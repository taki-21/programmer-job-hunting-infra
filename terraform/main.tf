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

module "ecs_cluster" {
  source = "./ecs_cluster"
  app_name = var.app_name
}

# module "ecs_rails" {
#   source = "./ecs_rails"
#   app_name    = var.app_name
#   db_name     = var.db_name
#   db_username = var.db_username
#   db_password = var.db_password
#   db_host     = module.rds.db_address
#   master_key  = var.master_key
#   vpc_id             = module.network.vpc_id
#   http_listener_arn  = module.elb.http_listener_arn
#   https_listener_arn = module.elb.https_listener_arn
#   alb_security_group = module.elb.alb_security_group
#   cluster_name       = module.ecs_cluster.cluster_name
#   public_subnet_ids  = module.network.public_subnet_ids
# }

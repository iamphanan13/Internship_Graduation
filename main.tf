
module "role" {
  source = "./modules/role"
}


module "network" {
  source               = "./modules/network"
  cidr_block           = var.cidr_block
  region               = var.region
  prefix               = var.prefix
  availability_zones_1 = var.availability_zones_1
  availability_zones_2 = var.availability_zones_2
  public_subnet_block  = var.public_subnet_block
  private_subnet_block = var.private_subnet_block
  data_subnet_block    = var.data_subnet_block
  security_group       = [module.security.vpc_endpoint_sg_id]

}

module "database" {
  source             = "./modules/database"
  subnet_group_name  = module.network.db_subnet_group_name
  security_group_ids = [module.security.test_db_sg]
  prefix             = var.prefix
  # db_username        = var.db_username
  # db_password        = var.db_password
}


module "security" {
  source             = "./modules/security"
  region             = var.region
  vpc_cidr           = var.cidr_block
  vpc_id             = module.network.vpc_id
  prefix             = var.prefix
  private_cidr_block = [module.network.private_cidr_block[0], module.network.private_cidr_block[1]]
}

module "compute" {
  source           = "./modules/compute"
  vpc_id           = module.network.vpc_id
  prefix           = var.prefix
  public_subnet_id = module.network.public_subnet_ids[0]
  # private_subnet_id = module.network.private_subnet_ids[0]
  image_id = data.aws_ami.ubuntu.id
  # key_name                      = "ec2-lab01"
  instance_type         = var.instance_type
  ec2_security_group_id = [module.security.test_sg_id]
  # ec2_private_security_group_id = [module.security.test_private_sg]

  iam_instance_profile = module.role.instance_profile_name
}


# module "ecr" {
#   source          = "./modules/ecr"
#   repository_name = "internship-graduation-ecr"
# }

module "namespace" {
  source = "./modules/namespace"
  vpc_id = module.network.vpc_id

}

module "cluster" {
  source             = "./modules/cluster"
  execution_role_arn = module.role.execution_role_arn
  task_role_arn      = module.role.task_role_arn
  db_host            = module.database.db_endpoint_address
  prefix             = var.prefix
  vpc_id             = module.network.vpc_id
  subnets            = module.network.public_subnet_ids
  security_group     = [module.security.test_sg_id]
  cloudmap_arn       = module.namespace.cloudmap_arn
  be_security_group  = [module.security.test_private_sg]
  be_subnets         = module.network.private_subnet_ids
  fe_security_group  = [module.security.test_sg_ecs_id]
  fe_subnets         = module.network.public_subnet_ids
}

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
  security_group       = [module.security.vpc_endpoint_sg_id]

}


module "security" {
  source   = "./modules/security"
  region   = var.region
  vpc_cidr = var.cidr_block
  vpc_id   = module.network.vpc_id
  prefix   = var.prefix
}

module "compute" {
  source            = "./modules/compute"
  prefix            = var.prefix
  public_subnet_id  = module.network.public_subnet_ids[0]
  private_subnet_id = module.network.private_subnet_ids[0]
  image_id          = data.aws_ami.ubuntu.id
  # key_name                      = "ec2-lab01"
  instance_type                 = var.instance_type
  ec2_security_group_id         = [module.security.public_sg_id]
  ec2_private_security_group_id = [module.security.application_tier_instance_sg]

  iam_instance_profile = module.role.instance_profile_name
}


module "ecr" {
  source = "./modules/ecr"
  repository_name = "internship-graduation-ecr"
}
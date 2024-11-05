module "network" {
  source               = "./modules/network"
  cidr_block           = var.cidr_block
  region               = var.region
  availability_zones_1 = var.availability_zones_1
  availability_zones_2 = var.availability_zones_2
  public_subnet_block  = var.public_subnet_block
  private_subnet_block = var.private_subnet_block

}
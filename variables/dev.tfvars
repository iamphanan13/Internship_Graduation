region               = "ap-southeast-1"
availability_zones_1 = "ap-southeast-1a"
availability_zones_2 = "ap-southeast-1b"

cidr_block           = "10.10.0.0/16"
public_subnet_block  = ["10.10.1.0/24", "10.10.2.0/24"]
private_subnet_block = ["10.10.3.0/24", "10.10.4.0/24"]
data_subnet_block    = ["10.10.5.0/24", "10.10.6.0/24"]
instance_type        = "t2.micro"

prefix = "dev"
resource "aws_vpc" "main" {
  cidr_block           = var.cidr_block
  enable_dns_hostnames = true
  tags = {
    Name = "Internship Graduation VPC"
  }
}


resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "Internship Graduation IGW"
  }
}

# Create public subnet 01

resource "aws_subnet" "public_subnet_01" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.public_subnet_block[0]
  availability_zone = var.availability_zones_1
  tags = {
    Name = "Internship Graduation Public Subnet 01"
  }
}

# Create public subnet 02

resource "aws_subnet" "public_subnet_02" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.public_subnet_block[1]
  availability_zone = var.availability_zones_2
  tags = {
    Name = "Internship Graduation Public Subnet 02"
  }
}


# Create private subnet 01

resource "aws_subnet" "private_subnet_01" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.private_subnet_block[0]
  availability_zone = var.availability_zones_1
  tags = {
    Name = "Internship Graduation Private Subnet 01"
  }
}

# Create private subnet 02
resource "aws_subnet" "private_subnet_02" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.private_subnet_block[1]
  availability_zone = var.availability_zones_2
  tags = {
    Name = "Internship Graduation Private Subnet 02"
  }
}

# Create Elastic IP 
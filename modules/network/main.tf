resource "aws_vpc" "main" {
  cidr_block           = var.cidr_block
  enable_dns_hostnames = true
  tags = {
    Name = "${var.prefix}-vpc"
  }
}


resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "${var.prefix}-igw"
  }
}

# Create public subnet 01

resource "aws_subnet" "public_subnet_01" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.public_subnet_block[0]
  availability_zone = var.availability_zones_1
  tags = {
    Name = "${var.prefix}-public-subnet-01"
  }
}

# Create public subnet 02

resource "aws_subnet" "public_subnet_02" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.public_subnet_block[1]
  availability_zone = var.availability_zones_2
  tags = {
    Name = "${var.prefix}-public-subnet-02"
  }
}


# Create private subnet 01

resource "aws_subnet" "private_subnet_01" {
  vpc_id                  = aws_vpc.main.id
  map_public_ip_on_launch = false
  cidr_block              = var.private_subnet_block[0]
  availability_zone       = var.availability_zones_1
  tags = {
    Name = "${var.prefix}-private-subnet-01"
  }
}

# Create private subnet 02
resource "aws_subnet" "private_subnet_02" {
  vpc_id                  = aws_vpc.main.id
  map_public_ip_on_launch = false
  cidr_block              = var.private_subnet_block[1]
  availability_zone       = var.availability_zones_2
  tags = {
    Name = "${var.prefix}-private-subnet-02"
  }
}

resource "aws_subnet" "data_subnet_01" {
  vpc_id                  = aws_vpc.main.id
  map_public_ip_on_launch = false
  cidr_block              = var.data_subnet_block[0]
  availability_zone       = var.availability_zones_1

  tags = {
    Name = "${var.prefix}-db-subnet-01"
  }
}

resource "aws_subnet" "data_subnet_02" {
  vpc_id                  = aws_vpc.main.id
  map_public_ip_on_launch = false
  cidr_block              = var.data_subnet_block[1]
  availability_zone       = var.availability_zones_2

  tags = {
    Name = "${var.prefix}-db-subnet-02"
  }
}

resource "aws_db_subnet_group" "db_subnet_group" {
  name       = "db-subnet-group"
  subnet_ids = [aws_subnet.data_subnet_01.id, aws_subnet.data_subnet_02.id]

  tags = {
    Name = "${var.prefix}-db-subnet-group"
  }
}

# Create Elastic IP 

# resource "aws_eip" "eip" {
#   tags = {
#     Name = "${var.prefix}-nat-ip"
#   }
# }

# resource "aws_nat_gateway" "nat_gw" {
#   allocation_id = aws_eip.eip.id
#   subnet_id     = aws_subnet.public_subnet_01.id
# }

# Create public route table

resource "aws_route_table" "public_rtb" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = {
    Name = "${var.prefix}-public-route-table"
  }
}


# Create private route table
resource "aws_route_table" "private_rtb" {
  vpc_id = aws_vpc.main.id
  # route {
  #   cidr_block     = "0.0.0.0/0"
  #   nat_gateway_id = aws_nat_gateway.nat_gw.id
  # }
  tags = {
    Name = "${var.prefix}-private-route-table"
  }
}
# Associate Public Subnet with Public Route Table
resource "aws_route_table_association" "public_rta_01" {
  subnet_id      = aws_subnet.public_subnet_01.id
  route_table_id = aws_route_table.public_rtb.id
}

resource "aws_route_table_association" "public_rta_02" {
  subnet_id      = aws_subnet.public_subnet_02.id
  route_table_id = aws_route_table.public_rtb.id
}

# Associate Private Subnet with Private Route Table
resource "aws_route_table_association" "private_rta_01" {
  subnet_id      = aws_subnet.private_subnet_01.id
  route_table_id = aws_route_table.private_rtb.id

}

resource "aws_route_table_association" "private_rta_02" {
  subnet_id      = aws_subnet.private_subnet_02.id
  route_table_id = aws_route_table.private_rtb.id

}




locals {
  services = {
    "ec2messages" : {
      "name" : "com.amazonaws.${var.region}.ec2messages"
    },
    "ssm" : {
      "name" : "com.amazonaws.${var.region}.ssm"
    },
    "ssmmessages" : {
      "name" : "com.amazonaws.${var.region}.ssmmessages"
    }
    "ecr_dkr" : {
      "name" : "com.amazonaws.${var.region}.ecr.dkr"
    }
    "ecr_api" : {
      "name" : "com.amazonaws.${var.region}.ecr.api"
    }
    "ecr_logs" : {
      "name" : "com.amazonaws.${var.region}.logs"
    }
  }
}

resource "aws_vpc_endpoint" "ssm_endpoint" {
  for_each            = local.services
  vpc_id              = aws_vpc.main.id
  service_name        = each.value.name
  vpc_endpoint_type   = "Interface"
  security_group_ids  = var.security_group
  private_dns_enabled = true
  ip_address_type     = "ipv4"
  subnet_ids          = [aws_subnet.private_subnet_01.id, aws_subnet.private_subnet_02.id]
}

resource "aws_vpc_endpoint" "ecr_s3_endpoint" {
  vpc_id            = aws_vpc.main.id
  service_name      = "com.amazonaws.${var.region}.s3"
  vpc_endpoint_type = "Gateway"
  route_table_ids   = [aws_route_table.private_rtb.id]


  tags = {
    Name = "${var.prefix}-s3-endpoint"
  }
}


# resource "aws_vpc_endpoint" "name" {

# }

# resource "aws_vpc_endpoint" "ssm_endpoint" {
#   vpc_id             = aws_vpc.main.id
#   service_name       = "com.amazonaws.${var.region}.ssm"
#   vpc_endpoint_type  = "Interface"
#   subnet_ids         = [aws_subnet.private_subnet_01.id, aws_subnet.private_subnet_02.id]
#   security_group_ids = var.security_group

#   tags = {
#     Name = "${var.prefix}-ssm-endpoint"
#   }
# }

# resource "aws_vpc_endpoint" "ssmmessages_endpoint" {
#   vpc_id             = aws_vpc.main.id
#   service_name       = "com.amazonaws.${var.region}.ssmmessages"
#   vpc_endpoint_type  = "Interface"
#   subnet_ids         = [aws_subnet.private_subnet_01.id, aws_subnet.private_subnet_02.id]
#   security_group_ids = var.security_group

#   tags = {
#     Name = "${var.prefix}-ssmmessages-endpoint"
#   }
# }

# resource "aws_vpc_endpoint" "ec2messages_endpoint" {
#   vpc_id             = aws_vpc.main.id
#   service_name       = "com.amazonaws.${var.region}.ec2messages"
#   vpc_endpoint_type  = "Interface"
#   subnet_ids         = [aws_subnet.private_subnet_01.id, aws_subnet.private_subnet_02.id]
#   security_group_ids = var.security_group

#   tags = {
#     Name = "${var.prefix}-ec2messages-endpoint"
#   }
# }
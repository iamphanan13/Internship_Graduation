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
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.private_subnet_block[0]
  availability_zone = var.availability_zones_1
  tags = {
    Name = "${var.prefix}-private-subnet-01"
  }
}

# Create private subnet 02
resource "aws_subnet" "private_subnet_02" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.private_subnet_block[1]
  availability_zone = var.availability_zones_2
  tags = {
    Name = "${var.prefix}-private-subnet-02"
  }
}

# Create Elastic IP 

resource "aws_eip" "eip" {
  tags = {
    Name = "${var.prefix}-nat-ip"
  }
}

resource "aws_nat_gateway" "nat_gw" {
  allocation_id = aws_eip.eip.id
  subnet_id     = aws_subnet.public_subnet_01.id
}

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
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gw.id
  }
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


resource "aws_vpc_endpoint" "ec2_endpoint" {
  vpc_id            = aws_vpc.main.id
  service_name      = "com.amazonaws.${var.region}.ssm"
  vpc_endpoint_type = "Interface"
  subnet_ids        = [aws_subnet.public_subnet_01.id, aws_subnet.public_subnet_02.id]

  security_group_ids = var.security_group
  tags = {
    Name = "${var.prefix}-ec2-endpoint"
  }
}
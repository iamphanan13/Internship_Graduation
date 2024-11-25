# Bastion Host (not enable SSH)
resource "aws_security_group" "public_sg" {
  name   = "${var.prefix}-public-sg"
  vpc_id = var.vpc_id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "allow http from anywhere"
  }
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "allow https from anywhere"

  }

  ingress {
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow ping from anywhere"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    "Name" = "${var.prefix}-public-sg"
  }
}

# Presentation Tier ALB
resource "aws_security_group" "presentation_tier_alb" {
  name   = "${var.prefix}-presentation-tier-alb"
  vpc_id = var.vpc_id
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow HTTP from anywhere"
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "${var.prefix}-presentation-tier-alb-sg"
  }
}
# Presentation Tier Instance
resource "aws_security_group" "presentation_tier_instance" {
  name   = "${var.prefix}-presentation-tier-instance"
  vpc_id = var.vpc_id

  ingress {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.presentation_tier_alb.id]
    description     = "Allow HTTP from ALB"
  }
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow HTTPS from anywhere"
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    "Name" = "${var.prefix}-presentation-tier-instance-sg"
  }
}

# Application Tier ALB
resource "aws_security_group" "application_tier_alb" {
  name   = "${var.prefix}-application-tier-alb"
  vpc_id = var.vpc_id
  ingress {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.presentation_tier_instance.id]
    description     = "Allow HTTP from Presentation Tier Instance"
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    "Name" = "${var.prefix}-application-tier-alb-sg"
  }
}

resource "aws_security_group" "application_tier_instance" {
  name   = "${var.prefix}-application-tier-instance"
  vpc_id = var.vpc_id
  ingress {
    from_port       = 3200
    to_port         = 3200
    protocol        = "tcp"
    security_groups = [aws_security_group.application_tier_alb.id]
    description     = "Allow TCP from ALB"
  }
  ingress {
    from_port       = 443
    to_port         = 443
    protocol        = "tcp"
    security_groups = [aws_security_group.public_sg.id]
    description     = "Allow HTTPS from Presentation Tier Instance"
  }
  ingress {
    description     = "Allow ICMP (ping) from public EC2"
    from_port       = -1                                # ICMP does not use port numbers, so set to -1
    to_port         = -1                                # -1 to allow all ICMP types and codes
    protocol        = "icmp"                            # Specify ICMP traffic
    security_groups = [aws_security_group.public_sg.id] # Reference the public EC2 SG
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    "Name" = "${var.prefix}-application-tier-instance-sg"
  }
}

resource "aws_security_group" "data_tier" {
  name   = "${var.prefix}-data-tier"
  vpc_id = var.vpc_id
  ingress {
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [aws_security_group.application_tier_instance.id]
    description     = "Allow MySQL from Application Tier Instance"
  }
  ingress {
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [aws_security_group.public_sg.id]
    description     = "Allow MySQL from Public SG"
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    "Name" = "${var.prefix}-data-tier-sg"
  }
}







# resource "aws_security_group" "private_sg" {
#   name   = "${var.prefix}-private-sg"
#   vpc_id = var.vpc_id

#   ingress {
#     from_port   = 3200
#     to_port     = 3200
#     protocol    = "tcp"
#     cidr_blocks = [aws_security_group.application_tier_alb]
#     # cidr_blocks = var.application_tier_alb_sg
#   }
#   egress {
#     from_port   = 0
#     to_port     = 0
#     protocol    = "-1"
#     cidr_blocks = ["0.0.0.0/0"]
#   }
# }

resource "aws_security_group" "vpc_endpoint_sg" {
  name        = "vpc-endpoint-sg"
  vpc_id      = var.vpc_id
  description = "Security group for VPC endpoint"

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.prefix}-vpc-endpoint-sg"
  }
}
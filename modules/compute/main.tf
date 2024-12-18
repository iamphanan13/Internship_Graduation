resource "aws_instance" "bastion_host" {
  ami           = var.image_id
  instance_type = var.instance_type
  # key_name               = var.key_name
  subnet_id              = var.public_subnet_id
  vpc_security_group_ids = var.ec2_security_group_id
  iam_instance_profile   = var.iam_instance_profile

  tags = {
    Name = "${var.prefix}-public-instance"
  }
}

# resource "aws_instance" "private_instance" {
#   vpc_security_group_ids      = var.ec2_private_security_group_id
#   ami                         = var.image_id
#   subnet_id                   = var.private_subnet_id
#   instance_type               = var.instance_type
#   associate_public_ip_address = false
#   iam_instance_profile        = var.iam_instance_profile

#   tags = {
#     Name = "${var.prefix}-private-instance"
#   }
# }

resource "aws_eip" "eip" {
  instance = aws_instance.bastion_host.id
}



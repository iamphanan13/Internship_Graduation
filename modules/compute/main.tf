resource "aws_instance" "bastion_host" {
  ami                    = var.image_id
  instance_type          = var.instance_type
  key_name               = var.key_name
  vpc_security_group_ids = var.ec2_security_group_id

  tags = {
    Name = "${var.prefix}-public-sg"
  }
}

resource "aws_eip" "eip" {
  instance = aws_instance.bastion_host.id
}
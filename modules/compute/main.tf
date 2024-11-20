

resource "aws_instance" "bastion_host" {
  ami                    = var.image_id
  instance_type          = var.instance_type
  key_name               = var.key_name
  subnet_id              = var.subnet_id
  vpc_security_group_ids = var.ec2_security_group_id
  iam_instance_profile   = var.iam_instance_profile

  tags = {
    Name = "${var.prefix}-instance"
  }
}

resource "aws_eip" "eip" {
  instance = aws_instance.bastion_host.id
}
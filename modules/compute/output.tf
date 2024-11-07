output "bastion_host_ip" {
  value = aws_eip.eip.public_ip
}
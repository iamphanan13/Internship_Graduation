output "bastion_host_ip" {
  value = aws_eip.eip.public_ip
}

output "instance_id" {
  value = aws_instance.bastion_host.id
}
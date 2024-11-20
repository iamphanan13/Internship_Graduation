output "public_sg_id" {
  value = aws_security_group.public_sg.id
}

output "vpc_endpoint_sg_id" {
  value = aws_security_group.vpc_endpoint_sg.id

}
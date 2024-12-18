output "public_sg_id" {
  value = aws_security_group.public_sg.id
}

output "vpc_endpoint_sg_id" {
  value = aws_security_group.vpc_endpoint_sg.id

}

output "application_tier_alb_sg" {
  value = aws_security_group.presentation_tier_alb.id
}

output "application_tier_instance_sg" {
  value = aws_security_group.application_tier_instance.id
}

output "test_db_sg" {
  value = aws_security_group.test_db_sg.id
}

output "test_private_sg" {
  value = aws_security_group.test_private_sg.id
}

output "test_sg_id" {
  value = aws_security_group.test_public_sg.id

}

output "test_sg_ecs_id" {
  value = aws_security_group.test_public_ecs_sg.id
}
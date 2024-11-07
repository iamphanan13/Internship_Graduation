output "vpc_id" {
  value = aws_vpc.main.id

}

output "public_subnet_ids" {
  value = [
    aws_subnet.public_subnet_01.id,
    aws_subnet.public_subnet_02.id
  ]
}

output "private_subnet_ids" {
  value = [
    aws_subnet.private_subnet_01.id,
    aws_subnet.private_subnet_02.id
  ]
}

output "public_route_table_id" {
  value = aws_route_table.public_rtb.id
}

output "private_route_table_id" {
  value = aws_route_table.private_rtb.id
}



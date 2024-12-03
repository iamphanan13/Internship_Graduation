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

output "private_cidr_block" {
  value = [
    aws_subnet.private_subnet_01.cidr_block,
    aws_subnet.private_subnet_02.cidr_block
  ]
}

output "public_route_table_id" {
  value = aws_route_table.public_rtb.id
}

output "db_subnet_group_name" {
  value = aws_db_subnet_group.db_subnet_group.name

}

output "private_route_table_id" {
  value = aws_route_table.private_rtb.id
}

output "vpc_cidr_block" {
  value = aws_vpc.main.cidr_block

}

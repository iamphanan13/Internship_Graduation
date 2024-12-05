output "instance_public_ip" {
  value = module.compute.bastion_host_ip

}

output "instance_id" {
  value = module.compute.instance_id
}

# output "ecr_fe_url" {
#   value = module.ecr.ecr_repository_url_fe
# }

# output "ecr_be_url" {
#   value = module.ecr.ecr_repository_url_be
# }

# output "private_instance_id" {
#   value = module
# }

# output "db_endpoint" {
#   value = module.database.db_endpoint
# }
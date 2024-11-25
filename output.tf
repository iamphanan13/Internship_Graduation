output "instance_public_ip" {
  value = module.compute.bastion_host_ip

}

output "instance_id" {
  value = module.compute.instance_id
}

# output "private_instance_id" {
#   value = module
# }
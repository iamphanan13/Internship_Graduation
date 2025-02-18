variable "security_group_ids" {
  type = list(string)
}

variable "subnet_group_name" {
  type = string
}

variable "prefix" {
  type = string

}

# variable "db_username" {
#   type      = string
#   sensitive = true
# }

# variable "db_password" {
#   type      = string
#   sensitive = true
# }
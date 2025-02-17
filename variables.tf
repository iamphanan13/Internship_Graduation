variable "cidr_block" {

}

variable "region" {

}

variable "availability_zones_1" {

}

variable "availability_zones_2" {

}


variable "public_subnet_block" {
  type = list(string)

}

variable "private_subnet_block" {
  type = list(string)

}

variable "data_subnet_block" {
  type = list(string)

}

variable "prefix" {
  type     = string
  nullable = false
}

variable "instance_type" {
  type     = string
  nullable = false
}

# variable "image_id" {
#   type     = string
#   # default  = data.aws_ami.ubuntu.id

# }

variable "kp_path" {
  type    = string
  default = "./keypair/keypair.pem"
}

variable "db_username" {
  type      = string
  sensitive = true

}

variable "db_password" {
  type      = string
  sensitive = true
}
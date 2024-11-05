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

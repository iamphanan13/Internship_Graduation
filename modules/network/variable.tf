variable "region" {
  type    = string
  default = "ap-southeast-1"
}

variable "cidr_block" {
  type     = string
  nullable = false
}

variable "public_subnet_block" {
  type     = list(string)
  nullable = false
}

variable "private_subnet_block" {
  type     = list(string)
  nullable = false

}

variable "availability_zones_1" {
  type = string
}


variable "availability_zones_2" {
  type = string
}

variable "security_group" {
}

variable "prefix" {

}
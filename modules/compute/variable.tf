variable "prefix" {
  type = string
}

variable "image_id" {
  type = string
  # nullable = false
}

variable "instance_type" {
  type = string
}

variable "public_subnet_id" {
  type = string
}

variable "private_subnet_id" {
  type = string
}

# variable "key_name" {
#   type = string
# }

variable "ec2_security_group_id" {
  type = list(string)
}

variable "ec2_private_security_group_id" {
  type = list(string)
}

variable "iam_instance_profile" {
  type = string
}

variable "vpc_id" {
  type = string

}
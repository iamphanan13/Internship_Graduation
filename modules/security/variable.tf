variable "prefix" {
  type = string
}

variable "region" {
  type = string
}

variable "vpc_id" {
  type     = string
  nullable = false
}

variable "vpc_cidr" {

}

# variable "application_tier_alb_sg" {

# }

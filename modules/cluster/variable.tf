variable "execution_role_arn" {
  type = string
}

variable "db_host" {
  type = string

}
variable "prefix" {
  type = string
}

variable "vpc_id" {
  type = string
}

variable "subnets" {
  type = list(string)

}

variable "security_group" {
  type = list(string)
}

variable "task_role_arn" {
  type = string
}

variable "cloudmap_arn" {
  type = string

}

variable "be_security_group" {
  type = list(string)
}

variable "be_subnets" {
  type = list(string)
}

variable "fe_security_group" {
  type = list(string)
}

variable "fe_subnets" {
  type = list(string)
}
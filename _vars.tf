variable "name" {
  type = string
}

variable "vpc_id" {
  type = string
}

variable "subnets" {
  type = list(string)
}

variable "instance_type" {
  type = string
}

variable "instance_key_name" {
  type = string
}

variable "instance_storage" {
  type = number
}

variable "max_instances_count" {
  type = number
  description = "The maximum number of instances to provision in the cluster."
  default = 10
}

variable "ingress_cidr_blocks" {
  type = map(any)
  default = {}
}

variable "ingress_security_groups" {
  type = map(any)
  default = {}
}

variable "extra_security_groups" {
  type = list(string)
  default = []
}

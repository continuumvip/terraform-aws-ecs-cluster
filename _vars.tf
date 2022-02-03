variable "name" {
  description = "The name of the cluster to manage."
  type = string
}

variable "subnets" {
  description = "The subnets to place objects in."
  type = list(string)
}

variable "instance_type" {
  description = "The instance type of the EC2 hosts to spin up."
  type = string
}

variable "instance_key_name" {
  description = "The SSH key name in EC2 to manually connect to hosts."
  type = string
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

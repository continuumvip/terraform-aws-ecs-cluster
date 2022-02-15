# ecs-application

A Terraform module to manage an AWS ECS cluster.


## Usage example

```hcl
module "ecs_cluster" {
  source = "emyller/ecs-cluster/aws"
  version = "~> 1.0"

  name = "production-web"
  subnets = module.vpc.private_subnets
  instance_type = "m5.large"
  instance_key_name = "production-2020-01-01"
  ingress_security_groups = {
    "ssh-from-production-vpn" = module.vpn.security_group_id
  }
}
```

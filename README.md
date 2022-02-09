# ecs-application

Manage an ECS cluster.


## Example

```hcl
module "ecs_cluster" {
  source = "..."

  name = "production-web"
  subnets = module.vpc.private_subnets
  instance_type = "m5.large"
  instance_key_name = "production-2020-01-01"
  ingress_security_groups = {
    "ssh-from-production-vpn" = module.vpn.security_group_id
  }
}
```

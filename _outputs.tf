output "arn" {
  value = aws_ecs_cluster.main.arn
}

output "instances_security_group_id" {
  value = module.security_group_ecs_instances.id
}

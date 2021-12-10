resource "aws_ecs_cluster" "main" {
  /*
  The ECS cluster itself
  */
  name = var.name
  capacity_providers = [aws_ecs_capacity_provider.main.name]

  default_capacity_provider_strategy {
    capacity_provider = aws_ecs_capacity_provider.main.name
    weight = 100
  }
}

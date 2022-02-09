resource "aws_autoscaling_group" "main" {
  /*
  The Auto Scaling Group to launch EC2 nodes
  */
  name = var.name
  min_size = 1
  max_size = var.max_instances_count
  vpc_zone_identifier = var.subnets
  protect_from_scale_in = true  # Required for the ECS capacity management

  tag {  # Required for the ECS capacity management
    key = "AmazonECSManaged"
    value = ""
    propagate_at_launch = true
  }

  launch_template {
    id = aws_launch_template.main.id
    version = aws_launch_template.main.latest_version
  }

  # Refresh instances automatically after changes
  instance_refresh {
    strategy = "Rolling"
  }
}

resource "aws_ecs_capacity_provider" "main" {
  /*
  The mechanism to allow auto scaling in the ECS cluster
  */
  name = "${var.name}-autoscaling"

  auto_scaling_group_provider {
    auto_scaling_group_arn = aws_autoscaling_group.main.arn
    managed_termination_protection = "ENABLED"

    managed_scaling {
      status = "ENABLED"
      target_capacity = 80
      minimum_scaling_step_size = 1
      maximum_scaling_step_size = 2
      instance_warmup_period = 300  # Seconds
    }
  }
}

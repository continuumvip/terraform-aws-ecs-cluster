data "aws_ami" "ecs" {
  /*
  Download ECS-optimized agent image info
  */
  most_recent = true
  owners = ["amazon"]

  filter {
    name = "name"
    values = ["amzn2-ami-ecs-inf-hvm-*-x86_64-ebs"]
  }
}

locals {
  # Gather data about the ECS AMI storage volume
  ami_volume = one(data.aws_ami.ecs.block_device_mappings)
}

resource "aws_launch_template" "main" {
  /*
  The Launch Template to launch EC2 nodes
  */
  name = var.name
  image_id = data.aws_ami.ecs.id
  instance_type = var.instance_type
  key_name = var.instance_key_name
  ebs_optimized = true
  user_data = base64encode(templatefile("${path.module}/nodes.user-data.sh.tpl", {
    cluster_name = var.name,
  }))

  iam_instance_profile {
    name = aws_iam_instance_profile.ecs_instance.name
  }

  tag_specifications {
    resource_type = "instance"
    tags = { "Name" = var.name }
  }

  network_interfaces {
    associate_public_ip_address = false
    security_groups = concat([
      module.security_group_ecs_instances.id,
    ], var.extra_security_groups)
  }

  monitoring {
    enabled = true
  }

  block_device_mappings {
    device_name = local.ami_volume.device_name
    ebs {
      delete_on_termination = true
      volume_size = local.ami_volume.ebs.volume_size  # Minimum defined by AMI
      volume_type = local.ami_volume.ebs.volume_type
    }
  }
}

module "security_group_ecs_instances" {
  /*
  The security group to wrap EC2 instances in HTTP services
  */
  source = "app.terraform.io/continuum/security-group/aws"
  version = "~> 1.0"
  name = "i-${var.name}"
  vpc_id = local.vpc_id
  ingress_security_groups = var.ingress_security_groups
  ingress_cidr_blocks = var.ingress_cidr_blocks
  allow_self_ingress = true
}

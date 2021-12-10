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

data "aws_ec2_instance_type" "main" {
  /*
  Download info about instance types
  */
  instance_type = var.instance_type
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
  user_data = base64encode(templatefile("${path.module}/user-data.sh", {
    cluster_name = local.cluster_name,
  }))

  iam_instance_profile {
    name = aws_iam_instance_profile.nodes.name
  }

  tag_specifications {
    resource_type = "instance"
    tags = {
      "Name" = var.name
    }
  }

  network_interfaces {
    associate_public_ip_address = false
    security_groups = concat([
      module.security_group_ec2_nodes.id,
    ], var.extra_security_groups)
  }

  monitoring {
    enabled = true
  }

  block_device_mappings {
    device_name = "/dev/xvda"

    ebs {
      delete_on_termination = true
      volume_size = var.instance_storage
      volume_type = "gp2"
    }
  }
}

module "security_group_ec2_nodes" {
  /*
  The security group to wrap EC2 instances
  */
  source = "app.terraform.io/continuum/security-group/aws"
  version = "~> 1.0"
  name = "i-${var.name}"
  vpc_id = var.vpc_id
  ingress_security_groups = var.ingress_security_groups
  ingress_cidr_blocks = var.ingress_cidr_blocks
  allow_self_ingress = true
}

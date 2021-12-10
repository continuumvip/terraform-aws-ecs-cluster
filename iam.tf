resource "aws_iam_role" "nodes" {
  name = "i-${var.name}"
  path = "/"
  assume_role_policy = data.aws_iam_policy_document.nodes_assume.json
}

resource "aws_iam_instance_profile" "nodes" {
  name = var.name
  role = aws_iam_role.nodes.name
}

data "aws_iam_policy_document" "nodes_assume" {
  statement {
    actions = ["sts:AssumeRole"]
    effect = "Allow"

    principals {
      type = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

resource "aws_iam_role_policy_attachment" "nodes_ecs" {
  role = aws_iam_role.nodes.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role"
}

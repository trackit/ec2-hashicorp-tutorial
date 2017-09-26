data "aws_iam_policy_document" "consul" {
  statement {
    actions = [
      "ec2:DescribeInstances",
    ]

    resources = [
      "*",
    ]
  }
}

data "aws_iam_policy_document" "assumerole" {
  statement {
    actions = [
      "sts:AssumeRole",
    ]

    principals {
      type = "Service"

      identifiers = [
        "ec2.amazonaws.com",
      ]
    }
  }
}

resource "aws_iam_policy" "consul" {
  name        = "ConsulEC2Discovery"
  description = "Allow Consul to discover peers using EC2 tags."
  policy      = "${data.aws_iam_policy_document.consul.json}"
}

resource "aws_iam_role" "consul" {
  name               = "ConsulAgent"
  assume_role_policy = "${data.aws_iam_policy_document.assumerole.json}"
}

resource "aws_iam_policy_attachment" "consul" {
  name = "consul"

  roles = [
    "${aws_iam_role.consul.id}",
  ]

  policy_arn = "${aws_iam_policy.consul.arn}"
}

resource "aws_iam_instance_profile" "consul" {
  name = "ConsulAgent"
  role = "${aws_iam_role.consul.id}"
}

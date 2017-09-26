resource "aws_security_group" "security_group" {
  name        = "nomad-cluster-member"
  description = "Security group for Nomad cluster members."
  vpc_id      = "${aws_vpc.vpc.id}"
}

resource "aws_security_group_rule" "incoming_ssh" {
  type              = "ingress"
  security_group_id = "${aws_security_group.security_group.id}"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "in_cluster_ingress" {
  type                     = "ingress"
  security_group_id        = "${aws_security_group.security_group.id}"
  from_port                = 0
  to_port                  = 0
  protocol                 = "-1"
  source_security_group_id = "${aws_security_group.security_group.id}"
}

resource "aws_security_group_rule" "in_cluster_egress" {
  type                     = "egress"
  security_group_id        = "${aws_security_group.security_group.id}"
  from_port                = 0
  to_port                  = 0
  protocol                 = "-1"
  source_security_group_id = "${aws_security_group.security_group.id}"
}

resource "aws_security_group_rule" "all_egress" {
  type              = "egress"
  security_group_id = "${aws_security_group.security_group.id}"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
}

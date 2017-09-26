resource "aws_key_pair" "ssh" {
  key_name   = "ssh"
  public_key = "${file("ssh.pub")}"
}

resource "aws_launch_configuration" "master" {
  name_prefix   = "master-"
  image_id      = "${var.ami_master}"
  instance_type = "t2.nano"

  security_groups = [
    "${aws_security_group.security_group.id}",
  ]

  iam_instance_profile = "${aws_iam_instance_profile.consul.id}"
  key_name             = "${aws_key_pair.ssh.key_name}"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "master" {
  name     = "master"
  min_size = 3
  max_size = 3

  vpc_zone_identifier = [
    "${aws_subnet.subnet.id}",
  ]

  launch_configuration = "${aws_launch_configuration.master.id}"

  tag {
    key                 = "ConsulAgent"
    value               = "Server"
    propagate_at_launch = true
  }
}

resource "aws_launch_configuration" "slave" {
  name_prefix   = "slave-"
  image_id      = "${var.ami_slave}"
  instance_type = "m4.large"

  security_groups = [
    "${aws_security_group.security_group.id}",
  ]

  iam_instance_profile = "${aws_iam_instance_profile.consul.id}"
  key_name             = "${aws_key_pair.ssh.key_name}"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "slave" {
  name     = "slave"
  min_size = 2
  max_size = 2

  vpc_zone_identifier = [
    "${aws_subnet.subnet.id}",
  ]

  launch_configuration = "${aws_launch_configuration.slave.id}"

  tag {
    key                 = "ConsulAgent"
    value               = "Client"
    propagate_at_launch = true
  }
}

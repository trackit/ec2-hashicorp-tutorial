resource "aws_vpc" "vpc" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_subnet" "subnet" {
  vpc_id                  = "${aws_vpc.vpc.id}"
  availability_zone       = "us-east-1a"
  cidr_block              = "${cidrsubnet(aws_vpc.vpc.cidr_block, 4, 1)}"
  map_public_ip_on_launch = true
}

resource "aws_internet_gateway" "gateway" {
  vpc_id = "${aws_vpc.vpc.id}"
}

resource "aws_route_table" "table" {
  vpc_id = "${aws_vpc.vpc.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.gateway.id}"
  }
}

resource "aws_route_table_association" "association" {
  subnet_id      = "${aws_subnet.subnet.id}"
  route_table_id = "${aws_route_table.table.id}"
}

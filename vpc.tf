resource "aws_vpc" "vpc" {
	cidr_block = "${var.vpc_cidr}"
	tags = "${merge(var.tags, map("Name", format("%s", var.name)))}"
}


// Public Network
resource "aws_internet_gateway" "igw" {
	vpc_id = "${aws_vpc.vpc.id}"
	tags   = "${merge(var.tags, map("Name", format("%s-igw", var.name)))}"
}

resource "aws_route_table" "public" {
  vpc_id           = "${aws_vpc.vpc.id}"

  route {
  	cidr_block = "0.0.0.0/0"
  	gateway_id = "${aws_internet_gateway.igw.id}"
  }
  tags             = "${merge(var.tags, map("Name", format("%s-rt-public", var.name)))}"
}

// Public Subnet
resource "aws_subnet" "public-subnet" {
	vpc_id = "${aws_vpc.vpc.id}"
	cidr_block = "${var.public_subnet_cidr}"
	map_public_ip_on_launch = "true"
	tags   = "${merge(var.tags, map("Name", format("%s-public-subnet", var.name)))}"
}

resource "aws_route_table_association" "public_assoc" {
	subnet_id = "${aws_subnet.public-subnet.id}"
	route_table_id = "${aws_route_table.public.id}"
}

//Private Network

// Elastic IP for Nat gateway
resource "aws_eip" "nat-gateway-ip" {
	vpc = true
	depends_on = ["aws_vpc.vpc"]
}

resource "aws_nat_gateway" "nat-gateway" {
	allocation_id = "${aws_eip.nat-gateway-ip.id}"
	subnet_id = "${aws_subnet.public-subnet.id}"
	depends_on = ["aws_internet_gateway.igw"]
}



//Private Subnet
resource "aws_subnet" "private-subnet" {
	vpc_id = "${aws_vpc.vpc.id}"
	cidr_block = "${var.private_subnet_cidr}"
	map_public_ip_on_launch = "false"
	tags   = "${merge(var.tags, map("Name", format("%s-private-subnet", var.name)))}"
}

resource "aws_route" "private_nat_gateway" {
	route_table_id = "${aws_route_table.private.id}"
	nat_gateway_id = "${aws_nat_gateway.nat-gateway.id}"
	destination_cidr_block = "0.0.0.0/0"
}

resource "aws_route_table" "private" {
	vpc_id = "${aws_vpc.vpc.id}"
	tags   = "${merge(var.tags, map("Name", format("%s-private-rt", var.name)))}"
}

resource "aws_route_table_association" "private" {
	subnet_id = "${aws_subnet.private-subnet.id}"
	route_table_id = "${aws_route_table.private.id}"
}


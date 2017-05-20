output "vpc_id" {
	value = "${aws_vpc.vpc_id.id}"
}

output "public_subnet_cidr" {
	value = "${aws_subnet.public-subnet.id}"
}

output "private_subnet_cidr" {
	value = "${aws_subnet.private-subnet.id}"
}
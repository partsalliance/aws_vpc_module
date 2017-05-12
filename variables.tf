variable "aws_access_key" {}
variable "aws_secret_key" {}

variable "name" {
	description = "name of everything in here"
	default = "alpha"
}

variable "region" {
	description = "AWS region"
	default = "us-west-2"
}

variable "vpc_cidr" {
	description = "VPC cidr for tests"
	default = "172.20.0.0/24"
}

variable "public_subnet_cidr" {
	description = "CIDR for public subnet"
	default = "172.20.0.0/26"
}

variable "private_subnet_cidr" {
	description = "CIDR for private subnet"
	default = "172.20.0.64/26"
}

variable "tags" {
	type = "map"
	description = "A map of tags to add all resources"
	default = {
		Terraform = "True"
		Environment = "Test"
	}
}
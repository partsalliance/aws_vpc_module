variable "name" {}

variable "region" {}

variable "vpc_cidr" {}

variable "public_subnet_cidr" {}

variable "private_subnet_cidr" {}

variable "tags" {
	type = "map"
	description = "A map of tags to add all resources"
	default = {
		Terraform = "True"
		Environment = "Test"
	}
}
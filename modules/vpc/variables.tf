variable "project_id" {
  description = "The GCP project ID"
}

variable "region" {
  description = "The GCP region where the network will be created"
}

variable "vpc_name" {
  description = "The name of the VPC"
}

variable "subnets" {
  description = "A list of subnets within the VPC"
}

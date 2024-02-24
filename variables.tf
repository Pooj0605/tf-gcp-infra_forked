variable "project_id" {
  description = "The id of the project"
  type        = string
}

variable "credentials_file" {
  description = "The GCP credentials file path"
  type        = string
}

variable "region" {
  description = "custom_region"
  type        = string
}

variable "zone" {
  description = "custom_zone"
  type        = string
}

variable "vpc_name" {
  description = "customization of VPC"
  type        = string
  
}
variable "auto_create_subnetworks" {
  type = bool
  default = false
  
}
variable "routing_mode" {
  type = string
  default = "REGIONAL"
  
}
variable "subnets" {
  description = "The map of custom subnets"
  type = map(object({
    name          = string
    ip_cidr_range = string
    region        = string
  }))
}


variable "routes" {
  description = "The map of custom routes"
  type = map(object({
    name              = string
    dest_range        = string
    next_hop_internet = bool
    description       = string
    tags              = list(string)
    vpc_name          = string
  }))
}

variable "firewall_vpc" {
  description = "The name of the VPC where firewall rules will be applied"
  type        = string
}

variable "application_port" {
  description = "The port your application listens to"
  type        = number
}

variable "instance_name" {
  description = "Name of the instance"
  type        = string
}

variable "machine_type" {
  description = "Machine type of the instance"
  type        = string
}

variable "image" {
  description = "Boot disk image of the instance"
  type        = string
}

variable "boot_disk_size_gb" {
  description = "Size of the boot disk in GB"
  type        = number
}

variable "instance_subnet" {
  description = "The name of the subnet for the instance"
  type        = string
}

variable "source_ranges" {
  type = string
  default = "0.0.0.0/0"
}
variable "port" {
  type = string
  default = "22"
}
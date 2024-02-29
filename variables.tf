//Variables for Provider
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

//Variables setting for VPC
variable "vpc_name" {
  description = "customization of VPC"
  type        = string

}
variable "auto_create_subnetworks" {
  type    = bool
  default = false

}
variable "routing_mode" {
  type    = string
  default = "REGIONAL"

}
//Variables for Subnets
variable "subnets" {
  description = "The map of custom subnets"
  type = map(object({
    name          = string
    ip_cidr_range = string
    region        = string
  }))
}
variable "private-ip-access" {
  type    = bool
  default = true
}

//Variables for global address
variable "global_address_name" {
  type = string
}
variable "vpc_purpose" {
  type    = string
  default = "VPC_PEERING"
}
variable "address_type" {
  type    = string
  default = "INTERNAL"
}
variable "prefix" {
  type    = string
  default = "16"
}

//Variables for Routes
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

//Variables for Firewall
variable "firewall_vpc" {
  description = "The name of the VPC where firewall rules will be applied"
  type        = string
}
variable "app-allow-name" {
  type = string
}
variable "allow-protocol-name" {
  type = string
}
variable "deny-ssh-Name" {
  type = string
}
variable "source_ranges" {
  type    = string
  default = "0.0.0.0/0"
}
variable "port" {
  type    = string
  default = "22"
}
variable "application_port" {
  description = "The port your application listens to"
  type        = number
}


//Variables for creating VM instances
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

//Variables for SQL intances 
variable "sql_instance_name" {
  type = string
}
variable "db_version" {
  type = string
}
variable "ipv4_enable" {
  type    = bool
  default = false
}
variable "del_proctection-rule" {
  type    = bool
  default = false
}
variable "db_machine_type" {
  type = string
}
variable "autoresize" {
  type    = bool
  default = true
}
variable "disktype" {
  type = string
}
variable "disksize" {
  type = string
}

//Variables for Database
variable "dbname" {
  type = string
}
variable "username" {
  type = string
}
variable "passlen" {
  type    = string
  default = "16"
}
variable "spl" {
  type    = bool
  default = false
}

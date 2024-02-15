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
  }))
}


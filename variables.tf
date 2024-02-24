variable "project_id" {
  description = "The GCP project ID"
}

variable "region" {
  description = "The GCP region to deploy resources into"
}

variable "vpcs" {
  description = "A map of VPC configurations"
  type = map(object({
    subnets = list(object({
      name          = string
      ip_cidr_range = string
      allow_ports = list(number)
    }))
  }))
}

# variable "zone" {
#   description = "The GCP zone to deploy resources into"
#   type        = string
# }

# variable "custom_image_self_link" {
#   description = "The self_link of the custom image built with Packer"
#   type        = string
# }

# variable "vpc_self_link" {
#   description = "The self_link of the VPC where the instance will be deployed"
#   type        = string
# }

# variable "service_account_email" {
#   description = "The email of the service account for the instance"
#   type        = string
# }

# variable "instances_configuration" {
#   description = "A map of instance configurations"
#   type = map(object({
#     name                = string
#     machine_type        = string
#     zone                = string
#     network             = string
#     subnetwork          = string
#     boot_image          = string
#     boot_disk_type      = string
#     boot_disk_size_gb   = number
#     tags                = list(string)
#   }))
# }

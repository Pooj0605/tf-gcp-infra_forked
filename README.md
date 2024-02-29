Terraform VPC Creation
This repository contains Terraform configuration files designed for creating and managing a Virtual Private Cloud (VPC) along with its associated subnets and routing on Google Cloud Platform (GCP).

Configuration Files
The project includes the following Terraform configuration files:

main.tf: This file contains the provider information, specifically for GCP, and configurations for VM instances.
variables.tf: Defines the variables utilized within the configuration, enabling customization and reusability of the code.
network.tf: Contains networking settings required for VM instances using VPC and VPC peering.
database.tf: Consists of database settings for VM instances utilizing Cloud SQL.
script.sh: Used to execute the web application during VM instance creation.
Prerequisites
Before getting started, ensure you have the following:

Terraform installed on your machine.
A Google Cloud Platform (GCP) account and gcloud CLI configured.
Necessary permissions to create and manage VPC resources within your GCP account.
The Google Compute Engine API (google_compute_API) enabled in your GCP project.
Ensure VPC peering is configured, allowing Cloud SQL instances to only connect with the web application and not other networks.
Usage
To create your VPC, subnets, and routing, follow these steps using Terraform. Replace the variable placeholders with your desired values:

Run the following command to initialize Terraform:
sh
Copy code
terraform init
Execute the Terraform apply command with the necessary variables replaced:
sh
Copy code
terraform apply \
  -var="vpc_name=your_vpc_name" \
  -var="subnet_name=your_subnet_name" \
  -var="subnet_ip_cidr_range=your_subnet_cidr" \
  -var="subnet_region=your_subnet_region" \
  -var="route_name=your_route_name" \
  -var="route_dest_range=your_route_destination" \
  -var="route_next_hop_gateway=your_next_hop_gateway"


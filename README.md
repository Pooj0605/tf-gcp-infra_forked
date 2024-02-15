# Terraform VPC Creation

This project contains Terraform configuration files for creating and managing a VPC (Virtual Private Cloud), along with its associated subnets and routing on Google Cloud Platform (GCP).

## Configuration Files

The project includes the following Terraform configuration files:

- `main.tf`: Contains the main set of Terraform configuration code for creating the VPC resources.
- `variables.tf`: Defines the variables used within the configuration, allowing for customization and reusability of the code.

## Prerequisites

Before you begin, ensure you have the following:

- Terraform installed on your machine.
- GCP account and a configured `gcloud` CLI.
- Necessary permissions to create and manage VPC resources in your GCP account.
- The Google Compute Engine API (`google_compute_API`) enabled in your GCP project.

## Usage

To create your VPC, subnets, and a route, use the following commands with Terraform. Replace the variable placeholders with your desired values:

```sh
terraform apply -var="vpc_name=your_new_vpc_name" -var="another_variable=another_value"

terraform apply \
  -var="vpc_name=your_vpc_name" \
  -var="subnet_name=your_subnet_name" \
  -var="subnet_ip_cidr_range=your_subnet_cidr" \
  -var="subnet_region=your_subnet_region" \
  -var="route_name=your_route_name" \
  -var="route_dest_range=your_route_destination" \
  -var="route_next_hop_gateway=your_next_hop_gateway"


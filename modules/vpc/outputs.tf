output "vpc_id" {
  value = google_compute_network.vpc.id
}

output "subnet_ids" {
  value = { for subnet in google_compute_subnetwork.subnets : subnet.name => subnet.id }
}

output "vpc_self_link" {
  value = google_compute_network.vpc.self_link
}


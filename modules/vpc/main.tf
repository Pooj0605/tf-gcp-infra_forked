resource "google_compute_network" "vpc" {
  name                    = var.vpc_name
  auto_create_subnetworks = false
  routing_mode            = "REGIONAL"
}

resource "google_compute_subnetwork" "subnets" {
  for_each = { for subnet in var.subnets : subnet.name => subnet }

  name          = each.value.name
  region        = var.region
  network       = google_compute_network.vpc.id
  ip_cidr_range = each.value.ip_cidr_range
}

resource "google_compute_route" "internet_access" {
  for_each = { for subnet in var.subnets : subnet.name => subnet if subnet.name == "webapp" }

  name            = "${each.value.name}-internet-access"
  dest_range      = "0.0.0.0/0"
  network         = google_compute_network.vpc.id
  next_hop_gateway = "default-internet-gateway"
  priority        = 1000
}



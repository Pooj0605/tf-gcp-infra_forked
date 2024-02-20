provider "google" {
  project     = var.project_id
  credentials = file(var.credentials_file)
  region      = var.region
  zone        = var.zone
}

resource "google_compute_network" " {
  name                    = var.vpc_name
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "terraform_subnet" {
  for_each = var.subnets

  name          = each.value.name
  ip_cidr_range = each.value.ip_cidr_range
  region        = each.value.region
  network       = google_compute_network.terraform_network.self_link
}

resource "google_compute_route" "route" {
  for_each = var.routes

  name         = each.value.name
  dest_range   = each.value.dest_range
  network      = google_compute_network.terraform_network.self_link
  description  = each.value.description
  tags         = each.value.tags
  next_hop_gateway = each.value.next_hop_internet ? "default-internet-gateway" : null
}


// VPC SETUP
resource "google_compute_network" "terraform_network" {
  name                    = var.vpc_name
  auto_create_subnetworks = var.auto_create_subnetworks

  routing_mode = var.routing_mode
}

// SUBNET SETUP
resource "google_compute_subnetwork" "terraform_subnet" {
  for_each = var.subnets

  name                     = each.value.name
  ip_cidr_range            = each.value.ip_cidr_range
  region                   = each.value.region
  network                  = google_compute_network.terraform_network.self_link
  private_ip_google_access = var.private-ip-access
}

// GLOBAL ADDRESS SETUP FOR PRIVATE ACCESS
resource "google_compute_global_address" "private_service_connect_address_terraform" {
  name          = var.global_address_name
  purpose       = var.vpc_purpose
  address_type  = var.address_type // Corrected typo: 'adddress_type' to 'address_type'
  prefix_length = var.prefix
  network       = google_compute_network.terraform_network.self_link // Corrected to use '.self_link'
}

// SERVICE NETWORKING CONNECTION SETUP FOR PRIVATE ACCESS
resource "google_service_networking_connection" "private_vpc_connection_terraform" {
  network                 = google_compute_network.terraform_network.self_link // Corrected to use '.self_link'
  service                 = "servicenetworking.googleapis.com"
  reserved_peering_ranges = [google_compute_global_address.private_service_connect_address_terraform.name]
}


//FIREWALL SETUP
resource "google_compute_firewall" "allow_application_traffic" {
  name    = var.app-allow-name
  network = google_compute_network.terraform_network.self_link

  allow {
    protocol = var.allow-protocol-name
    ports    = [tostring(var.application_port)]
  }

  source_ranges = [var.source_ranges]
}

resource "google_compute_firewall" "deny_ssh_traffic" {
  name    = var.deny-ssh-Name
  network = google_compute_network.terraform_network.self_link

  deny {
    protocol = var.allow-protocol-name
    ports    = [var.port]
  }

  source_ranges = [var.source_ranges]
}

// ROUTES SETUP FOR TRAFFIC
resource "google_compute_route" "route" {
  for_each         = var.routes
  name             = each.value.name
  dest_range       = each.value.dest_range
  network          = google_compute_network.terraform_network.self_link
  description      = each.value.description
  tags             = each.value.tags
  next_hop_gateway = each.value.next_hop_internet ? "default-internet-gateway" : null
}

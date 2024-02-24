provider "google" {
  project     = var.project_id
  credentials = file(var.credentials_file)
  region      = var.region
  zone        = var.zone
}

resource "google_compute_network" "terraform_network" {
  name                    = var.vpc_name
  auto_create_subnetworks = var.auto_create_subnetworks
  routing_mode            = var.routing_mode
}

resource "google_compute_subnetwork" "terraform_subnet" {
  for_each = var.subnets

  name          = each.value.name
  ip_cidr_range = each.value.ip_cidr_range
  region        = each.value.region
  network       = google_compute_network.terraform_network.self_link
}

resource "google_compute_firewall" "allow_application_traffic" {
  name    = "allow-application-traffic"
  network = google_compute_network.terraform_network.self_link

  allow {
    protocol = "tcp"
    ports    = [tostring(var.application_port)]
  }

  source_ranges = ["0.0.0.0/0"]
}

resource "google_compute_firewall" "deny_ssh_traffic" {
  name    = "deny-ssh-traffic"
  network = google_compute_network.terraform_network.self_link

  deny {
    protocol = "tcp"
    ports    = ["22"]
  }

  source_ranges = ["0.0.0.0/0"]
}

resource "google_compute_instance" "instance" {
  name         = var.instance_name
  machine_type = var.machine_type
  zone         = var.zone

  boot_disk {
    initialize_params {
      image = var.image
      size  = var.boot_disk_size_gb
    }
  }

  network_interface {
    # Ensure the subnet name matches one from your `var.subnets` map
    subnetwork = google_compute_subnetwork.terraform_subnet["subnet1"].self_link
    access_config {}
  }
}

resource "google_compute_route" "route" {
  for_each      = var.routes
  name          = each.value.name
  dest_range    = each.value.dest_range
  network       = google_compute_network.terraform_network.self_link
  description   = each.value.description
  tags          = each.value.tags
  next_hop_gateway = each.value.next_hop_internet ? "default-internet-gateway" : null
}

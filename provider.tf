provider "google" {
  credentials = "test.json"
  project = var.project_id
  region  = var.region
}

resource "google_compute_instance" "vm_instance" {
  for_each = var.instances_configuration

  name         = each.value.name
  machine_type = each.value.machine_type
  zone         = each.value.zone

  boot_disk {
    initialize_params {
      image = each.value.boot_image
      type  = each.value.boot_disk_type
      size  = each.value.boot_disk_size_gb
    }
  }

  network_interface {
    network    = each.value.network
    subnetwork = each.value.subnetwork
    // Assuming your VPC and subnets are already configured
  }

  service_account {
    email  = var.service_account_email
    scopes = ["https://www.googleapis.com/auth/cloud-platform"]
  }

  tags = each.value.tags

  metadata = {
    // Custom metadata can be added here
  }

  lifecycle {
    prevent_destroy = false
  }
}

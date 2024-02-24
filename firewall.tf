# Allow HTTP traffic to "csye-6225" VPC
resource "google_compute_firewall" "allow_http_csye_6225" {
  name    = "allow-http-csye-6225"
  network = module.vpc["csye-6225"].vpc_self_link

  allow {
    protocol = "tcp"
    ports    = ["80"]
  }

  target_tags   = ["http-server"]
  source_ranges = ["0.0.0.0/0"]
}

# Deny SSH traffic to "csye-6225" VPC
resource "google_compute_firewall" "deny_ssh_csye_6225" {
  name    = "deny-ssh-csye-6225"
  network = module.vpc["csye-6225"].vpc_self_link

  deny {
    protocol = "tcp"
    ports    = ["22"]
  }

  target_tags   = ["http-server", "ssh-server"] # Adjust the target tags as necessary
  source_ranges = ["0.0.0.0/0"]
}

# Allow HTTP traffic to "test-vpc" VPC
resource "google_compute_firewall" "allow_http_test_vpc" {
  name    = "allow-http-test-vpc"
  network = module.vpc["test-vpc"].vpc_self_link

  allow {
    protocol = "tcp"
    ports    = ["80"]
  }

  target_tags   = ["http-server"]
  source_ranges = ["0.0.0.0/0"]
}

# Deny SSH traffic to "test-vpc" VPC
resource "google_compute_firewall" "deny_ssh_test_vpc" {
  name    = "deny-ssh-test-vpc"
  network = module.vpc["test-vpc"].vpc_self_link

  deny {
    protocol = "tcp"
    ports    = ["22"]
  }

  target_tags   = ["http-server", "ssh-server"] # Adjust the target tags as necessary
  source_ranges = ["0.0.0.0/0"]
}

resource "google_compute_firewall" "allow_internal_ssh" {
  name    = "allow-internal-ssh"
  network = module.vpc["csye-6225"].vpc_self_link

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  # Use the IP range of your VPC to limit SSH access to internal sources
  source_ranges = ["10.0.1.0/24"]

  # Optionally, target only specific instances with a tag
  target_tags = ["packer-build"]
}
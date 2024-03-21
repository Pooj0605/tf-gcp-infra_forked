//PROVIDER SETUP
provider "google" {
  project     = var.project_id
  credentials = file(var.credentials_file)
  region      = var.region
  zone        = var.zone
}

data "template_file" "metadata_script" {

  template = file("${path.module}/script.sh")
  vars = {
    DB_HOST     = "${google_sql_database_instance.sql_instance_terraform.private_ip_address}"
    DB_USER     = "${google_sql_user.user_terraform.name}"
    DB_PASSWORD = "${random_password.password_terraform.result}"
    DB_NAME     = "${google_sql_database.terraform_database.name}"
  }
}

resource "google_compute_instance" "terraform_instance" {
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
    subnetwork = google_compute_subnetwork.terraform_subnet["subnet1"].self_link
    access_config {}
  }
  metadata_startup_script = data.template_file.metadata_script.rendered

  service_account {
    email  = google_service_account.service_account.email
    scopes = ["logging-write", "monitoring-write"]
  }
}



# //SERVICE ACCOUNT CREATION 
resource "google_service_account" "service_account" {
  account_id   = var.serviceid
  display_name = var.serviceaccname
}

//SERVICE ACCOUNT ROLES SETUP 

resource "google_project_iam_binding" "service_account_logging_admin" {
  project = var.project_id
  role    = "roles/logging.admin"

  members = [
    "serviceAccount:${google_service_account.service_account.email}"
  ]
}

resource "google_project_iam_binding" "service_account_metric_writer" {
  project = var.project_id
  role    = "roles/monitoring.metricWriter"

  members = [
    "serviceAccount:${google_service_account.service_account.email}"
  ]
}


//DNS A-RECORD SETUP
resource "google_dns_record_set" "dns-a-record-terraform" {
  name         = var.dns-name
  type         = var.recordtype
  ttl          = var.ttl
  managed_zone = var.managedzonename
  rrdatas      = [google_compute_instance.terraform_instance.network_interface[0].access_config[0].nat_ip]
}
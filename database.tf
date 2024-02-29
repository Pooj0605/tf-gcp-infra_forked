// SQL INSTANCES SETUP 
resource "google_sql_database_instance" "sql_instance_terraform" {
  name                = var.sql_instance_name
  region              = var.region
  database_version    = var.db_version
  deletion_protection = var.del_proctection-rule
  depends_on          = [google_service_networking_connection.private_vpc_connection_terraform]

  settings {
    tier              = var.db_machine_type
    availability_type = var.routing_mode
    disk_autoresize   = var.autoresize
    disk_size         = var.disksize
    disk_type         = var.disktype

    backup_configuration {
      enabled            = true
      binary_log_enabled = true

    }

    ip_configuration {
      ipv4_enabled                                  = var.ipv4_enable
      private_network                               = google_compute_network.terraform_network.self_link
      enable_private_path_for_google_cloud_services = true
    }
  }
}

//DATABASE SETUP 
resource "google_sql_database" "terraform_database" {
  name     = var.dbname
  instance = google_sql_database_instance.sql_instance_terraform.name
}
resource "google_sql_user" "user_terraform" {
  name     = var.username
  instance = google_sql_database_instance.sql_instance_terraform.name
  password = random_password.password_terraform.result
}
resource "random_password" "password_terraform" {
  length  = var.passlen
  special = var.spl

}

output "sql_instance_private_ip" {
  value = google_sql_database_instance.sql_instance_terraform.private_ip_address
}
output "sql_user_password" {
  value     = random_password.password_terraform.result
  sensitive = true
}

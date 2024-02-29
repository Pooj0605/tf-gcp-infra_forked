//PROVIDER SETUP
provider "google" {
  project     = var.project_id
  credentials = file(var.credentials_file)
  region      = var.region
  zone        = var.zone
}

data "template_file" "metadata_script" {
  
 template= file("${path.module}/script.sh")
 vars={ 
  DB_HOST ="${google_sql_database_instance.sql_instance_terraform.private_ip_address}"
  DB_USER="${google_sql_user.user_terraform.name}"
  DB_PASSWORD="${random_password.password_terraform.result}"
  DB_NAME="${google_sql_database.terraform_database.name}"
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
}
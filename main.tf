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

resource "google_compute_region_instance_template" "terraform-template" {
  name = var.template_name

  machine_type = var.machine_type
  tags         = [var.tag_name]

  disk {
    device_name = var.dev_name
    source_image = var.image
    auto_delete  = var.auto_del
    disk_size_gb = var.boot_disk_size_gb

    disk_encryption_key {
      kms_key_self_link = google_kms_crypto_key.terraform_vm_key.id
    }
  }

  network_interface {
    subnetwork = google_compute_subnetwork.terraform_subnet["subnet1"].self_link

  }
  metadata_startup_script = data.template_file.metadata_script.rendered

  service_account {
    email  = google_service_account.service_account.email
    scopes = var.scopes_list
  }

}


# //SERVICE ACCOUNT CREATION 
resource "google_service_account" "service_account" {
  account_id   = var.serviceid
  display_name = var.serviceaccname
}

resource "google_service_account" "cloud_service_account" {
  account_id   = var.cloud_serviceid
  display_name = var.cloud_serviceaccname
}

# resource "google_service_account" "storage_bucket_service_account" {
#   account_id   = var.storage_bucket_serviceid
#   display_name = var.storage_bucket_serviceaccname
# }



//SERVICE ACCOUNT ROLES SETUP 
resource "google_cloudfunctions2_function_iam_member" "functions_invoker_member" {

  cloud_function = google_cloudfunctions2_function.verify_email_function.name

  role   = var.role_cloudfn
  member = "serviceAccount:${google_service_account.cloud_service_account.email}"
}
resource "google_project_iam_binding" "service_account_logging_admin" {
  project = var.project_id
  role    = var.log_name

  members = [
    "serviceAccount:${google_service_account.service_account.email}"
  ]
}

resource "google_project_iam_binding" "service_account_metric_writer" {
  project = var.project_id
  role    = var.metric_name

  members = [
    "serviceAccount:${google_service_account.service_account.email}"
  ]
}

resource "google_project_iam_binding" "pubsub_publisher" {
  project = var.project_id
  role    = var.pub_role

  members = [
    "serviceAccount:${google_service_account.service_account.email}",
  ]
}

resource "google_project_iam_binding" "pubsub_subscriber" {
  project = var.project_id
  role    = var.sub_role

  members = [
    "serviceAccount:${google_service_account.service_account.email}",
  ]
}

resource "google_project_iam_binding" "terraform_kms_role" {
  project = var.project_id
  role    = var.kms_role

  members = [
    "serviceAccount:${google_service_account.cloud_service_account.email}",
  ]
}

resource "google_project_iam_binding" "terraform_cloud_fn" {
  project = var.project_id
  role    = "roles/run.invoker"

  members = [
    "serviceAccount:${google_service_account.cloud_service_account.email}",
  ]
}
# resource "google_project_iam_binding" "kms_cloud" {
#   project = var.project_id
#   role    = "roles/cloudkms.admin"

#   members = [
#     "serviceAccount:${google_service_account.storage_bucket_service_account.email}",
#   ]
# }



# resource "google_storage_bucket_iam_binding" "bucket_binding" {
#   bucket = google_storage_bucket.functions_bucket.name
#   role   = var.kms_role  

#   members = [
#     "serviceAccount:${google_service_account.storage_bucket_service_account.email}",
#   ]
# }

data "google_storage_project_service_account" "storage_bucket_account" {
}

resource "google_kms_crypto_key_iam_binding" "storage_bucket_enc_decrypt_binding" {
  crypto_key_id =google_kms_crypto_key.terraform_bucket_storage_key.id
  role          = "roles/cloudkms.cryptoKeyEncrypterDecrypter"

  members = [
    "serviceAccount:${data.google_storage_project_service_account.storage_bucket_account.email_address}"
  ]
}
data "google_project" "project" {
}

resource "google_kms_crypto_key_iam_binding" "vm_enc_decrypt_binding" {
  crypto_key_id = google_kms_crypto_key.terraform_vm_key.id
  role          = "roles/cloudkms.cryptoKeyEncrypterDecrypter"

  members = [
    "serviceAccount:service-${data.google_project.project.number}@compute-system.iam.gserviceaccount.com",
  ]
}





//DNS A-RECORD SETUP
resource "google_dns_record_set" "dns-a-record-terraform" {
  name         = var.dns-name
  type         = var.recordtype
  ttl          = var.ttl
  managed_zone = var.managedzonename
  rrdatas      = [google_compute_global_address.lb_ip.address]
}

resource "google_pubsub_topic" "terraform-pub" {
  name                       = var.pub_name
  message_retention_duration = var.ret_time
}

resource "google_pubsub_subscription" "terraform-sub" {
  name  = var.sub_name
  topic = google_pubsub_topic.terraform-pub.name

  ack_deadline_seconds = var.ack
}

data "archive_file" "function_source" {
  type        = var.type
  source_dir  = "${path.module}/Cloud_Function"
  output_path = "${path.module}/lb.zip"

}

resource "google_storage_bucket_object" "function_source" {
  name   = "lb.zip"
  bucket = google_storage_bucket.functions_bucket.name
  source = data.archive_file.function_source.output_path
}

resource "google_cloudfunctions2_function" "verify_email_function" {
  location = var.region
  name     = var.cloudfn

  build_config {
    runtime     = var.runtime
    entry_point = var.fun_entrypoint
    source {
      storage_source {
        bucket = google_storage_bucket.functions_bucket.name
        object = "lb.zip"
      }
    }
  }

  service_config {
    max_instance_count             = var.max
    available_memory               = var.memory
    timeout_seconds                = var.health_time
    ingress_settings               = var.settings
    all_traffic_on_latest_revision = var.enable
    service_account_email          = google_service_account.service_account.email
    environment_variables = {
      DB_HOST         = "${google_sql_database_instance.sql_instance_terraform.private_ip_address}"
      DB_USER         = "${google_sql_user.user_terraform.name}"
      DB_PASSWORD     = "${random_password.password_terraform.result}"
      DB_NAME         = "${google_sql_database.terraform_database.name}"
      MAILGUN_API_KEY = var.mailgun_api_key
      MYDOMAIN        = var.mydomain_name
    }
    vpc_connector                 = google_vpc_access_connector.serverlessvpc.id
    vpc_connector_egress_settings = var.engress
  }

  event_trigger {
    trigger_region = var.region
    event_type     = var.event
    pubsub_topic   = google_pubsub_topic.terraform-pub.id
     retry_policy          = var.retry
  }

}
resource "google_cloudfunctions2_function_iam_member" "functions_invoker_member" {

  cloud_function = google_cloudfunctions2_function.verify_email_function.name

  role   = var.role_cloudfn
  member = "serviceAccount:${google_service_account.service_account.email}"
}


resource "google_vpc_access_connector" "serverlessvpc" {
  name          = var.connector
  region        = var.region
  network       = var.vpc_name
  ip_cidr_range = var.serverlessip
}

resource "google_storage_bucket" "functions_bucket" {
  name          = "${var.project_id}-functions-bucket"
  location      =var.loc
  force_destroy = var.enable
}


# resource "google_storage_bucket_object" "function_source" {
#   name   = "testserverless.zip"
#   bucket = google_storage_bucket.functions_bucket.name
#   source = data.archive_file.function_source.output_path
# }


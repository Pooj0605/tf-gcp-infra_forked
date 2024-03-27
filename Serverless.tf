resource "google_pubsub_topic" "terraform-pub" {
  name                       = var.pub_name
  message_retention_duration = var.ret_time # 7 days in seconds
}

resource "google_pubsub_subscription" "terraform-sub" {
  name  = var.sub_name
  topic = google_pubsub_topic.terraform-pub.name

  ack_deadline_seconds = var.ack
}

data "archive_file" "function_source" {
  type        = "zip"
  source_dir  = "${path.module}/Cloud_Function"
  output_path = "${path.module}/finaltestserverless.zip"

}

resource "google_storage_bucket_object" "function_source" {
  name   = "finaltestserverless.zip"
  bucket = google_storage_bucket.functions_bucket.name
  source = data.archive_file.function_source.output_path
}

resource "google_cloudfunctions2_function" "verify_email_function" {
  location = var.region
  name     = "testingserverlessfn"


  build_config {
    runtime     = "nodejs20"
    entry_point = var.fun_entrypoint
    source {
      storage_source {
        bucket = google_storage_bucket.functions_bucket.name
        object = "finaltestserverless.zip"
      }
    }
  }

  service_config {
    max_instance_count             = 1
    available_memory               = "256Mi"
    timeout_seconds                = 60
    ingress_settings               = "ALLOW_INTERNAL_ONLY"
    all_traffic_on_latest_revision = true
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
    vpc_connector_egress_settings = "PRIVATE_RANGES_ONLY"
  }

  event_trigger {
    trigger_region = var.region
    event_type     = "google.cloud.pubsub.topic.v1.messagePublished"
    pubsub_topic   = google_pubsub_topic.terraform-pub.id
  }

}
resource "google_cloudfunctions2_function_iam_member" "functions_invoker_member" {

  cloud_function = google_cloudfunctions2_function.verify_email_function.name

  role   = "roles/cloudfunctions.invoker"
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
  location      = "US"
  force_destroy = true
}


# resource "google_storage_bucket_object" "function_source" {
#   name   = "testserverless.zip"
#   bucket = google_storage_bucket.functions_bucket.name
#   source = data.archive_file.function_source.output_path
# }


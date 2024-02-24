provider "google" {
  credentials = "test.json"
  project = var.project_id
  region  = var.region
}

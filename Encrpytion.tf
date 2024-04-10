
resource "google_kms_crypto_key" "terraform_sql_key" {
  name            = var.sql_key
  key_ring        =  var.keyring_name
  rotation_period = var.rotation_sec

  lifecycle {
    # Prevent accidental deletion of the encryption key
    prevent_destroy = false
  }
}
resource "google_kms_crypto_key" "terraform_vm_key" {
  name            = var.vm_key
  key_ring        = var.keyring_name
  rotation_period = var.rotation_sec

  lifecycle {
    # Prevent accidental deletion of the encryption key
    prevent_destroy = false
  }
}
resource "google_kms_crypto_key" "terraform_bucket_storage_key" {
  name            = var.storage_key
  key_ring        = var.keyring_name
  rotation_period = var.rotation_sec

  lifecycle {
    # Prevent accidental deletion of the encryption key
    prevent_destroy = false
  }
}

resource "google_kms_key_ring" "my_key_ring" {
  name     = var.key_ring
  location = var.region  

}


# Example: Customer-Managed Encryption Setup
# This is an advanced configuration for production environments

# Enable Cloud KMS API (required for customer-managed keys)
resource "google_project_service" "cloudkms" {
  service = "cloudkms.googleapis.com"
}

# Create a KMS key ring
resource "google_kms_key_ring" "storage_keyring" {
  name     = "storage-keyring"
  location = var.region
  
  depends_on = [google_project_service.cloudkms]
}

# Create a KMS crypto key
resource "google_kms_crypto_key" "storage_key" {
  name     = "storage-key"
  key_ring = google_kms_key_ring.storage_keyring.id
  
  lifecycle {
    prevent_destroy = true
  }
}

# Storage bucket with customer-managed encryption
resource "google_storage_bucket" "function_bucket_cmek" {
  name     = "${var.project_id}-functions-secure"
  location = var.region

  uniform_bucket_level_access = true

  encryption {
    default_kms_key_name = google_kms_crypto_key.storage_key.id
  }

  versioning {
    enabled = true
  }

  depends_on = [google_kms_crypto_key.storage_key]
}
# Security Fix Example for main.tf
# This file shows how to fix the security issues found by tfsec

# # Fix #1: Enable uniform bucket level access
# resource "google_storage_bucket" "function_bucket_secure" {
#   name     = "${var.project_id}-functions"
#   location = var.region

#   # Enable uniform bucket level access (fixes MEDIUM security issue)
#   uniform_bucket_level_access = true

#   # Optional: Add versioning for better security
#   versioning {
#     enabled = true
#   }

#   # Optional: Add lifecycle management
#   lifecycle_rule {
#     condition {
#       age = 30
#     }
#     action {
#       type = "Delete"
#     }
#   }
# }

# Fix #2: Add encryption with customer-managed key (optional - requires KMS setup)
# This is an advanced fix that requires setting up Cloud KMS first
# Uncomment and modify the following if you want customer-managed encryption:

# resource "google_storage_bucket" "function_bucket_with_cmek" {
#   name     = "${var.project_id}-functions"
#   location = var.region
#   
#   uniform_bucket_level_access = true
#   
#   encryption {
#     default_kms_key_name = "projects/YOUR_PROJECT/locations/YOUR_REGION/keyRings/YOUR_KEYRING/cryptoKeys/YOUR_KEY"
#   }
# }
terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 6.0"
    }
  }
  required_version = ">= 1.5.0"
}

provider "google" {
  project = var.project_id
  region  = var.region
}

# Enable Cloud Functions API
resource "google_project_service" "cloudfunctions" {
  service = "cloudfunctions.googleapis.com"
}

# Enable Cloud Build (required for deploy)
resource "google_project_service" "cloudbuild" {
  service = "cloudbuild.googleapis.com"
}

# Create a storage bucket to store function source code
resource "google_storage_bucket" "function_bucket" { #tfsec:ignore:google-storage-bucket-encryption-customer-key
  name     = "${var.project_id}-functions"
  location = var.region

  uniform_bucket_level_access = true

  versioning {
    enabled = true
  }
}

# Archive function source code into a ZIP
data "archive_file" "function_zip" {
  type        = "zip"
  source_dir  = "${path.module}/function"
  output_path = "${path.module}/function.zip"
}

# Upload ZIP to bucket
resource "google_storage_bucket_object" "function_archive" {
  name   = "function.zip"
  bucket = google_storage_bucket.function_bucket.name
  source = data.archive_file.function_zip.output_path
}

# Deploy the Cloud Function (2nd gen example)
resource "google_cloudfunctions2_function" "hello_world" {
  name        = "hello-world"
  location    = var.region
  description = "Simple Hello World Function"

  build_config {
    runtime     = "python311"
    entry_point = "hello_world"
    source {
      storage_source {
        bucket = google_storage_bucket.function_bucket.name
        object = google_storage_bucket_object.function_archive.name
      }
    }
  }

  service_config {
    max_instance_count = 1
    available_memory   = "128M"
  }
}

variable "project_id" {
  description = "The ID of the GCP project"
  type        = string
  default     = "app-xyz-dev"
}

variable "region" {
  description = "GCP region for deployment"
  type        = string
  default     = "us-central1"
}



output "function_uri" {
  description = "The URL of the deployed Cloud Function"
  value       = google_cloudfunctions2_function.hello_world.service_config[0].uri
}




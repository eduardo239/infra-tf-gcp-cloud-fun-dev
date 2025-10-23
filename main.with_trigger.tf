# terraform {
#   required_providers {
#     google = {
#       source  = "hashicorp/google"
#       version = "~> 6.0"
#     }
#   }

#   required_version = ">= 1.5.0"
# }

# provider "google" {
#   project = var.project_id
#   region  = var.region
# }

# # Enable required APIs
# resource "google_project_service" "cloudfunctions" {
#   service = "cloudfunctions.googleapis.com"
# }

# resource "google_project_service" "cloudbuild" {
#   service = "cloudbuild.googleapis.com"
# }

# resource "google_project_service" "artifactregistry" {
#   service = "artifactregistry.googleapis.com"
# }

# # Bucket for function source code
# resource "google_storage_bucket" "function_bucket" {
#   name     = "${var.project_id}-functions"
#   location = var.region
# }

# # Zip the function source
# data "archive_file" "function_zip" {
#   type        = "zip"
#   source_dir  = "${path.module}/function"
#   output_path = "${path.module}/function.zip"
# }

# # Upload to GCS
# resource "google_storage_bucket_object" "function_archive" {
#   name   = "http-function.zip"
#   bucket = google_storage_bucket.function_bucket.name
#   source = data.archive_file.function_zip.output_path
# }

# # Deploy Cloud Function (HTTP Trigger)
# resource "google_cloudfunctions2_function" "hello_http" {
#   name        = "hello-http"
#   location    = var.region
#   description = "Simple HTTP Function"

#   build_config {
#     runtime     = "python311"
#     entry_point = "hello_world"
#     source {
#       storage_source {
#         bucket = google_storage_bucket.function_bucket.name
#         object = google_storage_bucket_object.function_archive.name
#       }
#     }
#   }

#   service_config {
#     max_instance_count = 1
#     available_memory   = "128M"
#     ingress_settings   = "ALLOW_ALL"
#   }
#   # removido event_trigger
# }

# # Allow unauthenticated access
# resource "google_cloud_run_service_iam_member" "public_invoker" {
#   location = var.region
#   service  = google_cloudfunctions2_function.hello_http.name
#   role     = "roles/run.invoker"
#   member   = "allUsers"
# }

# output "http_function_url" {
#   value = google_cloudfunctions2_function.hello_http.service_config[0].uri
# }


# ##

# # Create Pub/Sub topic
# resource "google_pubsub_topic" "hello_topic" {
#   name = "hello-topic"
# }

# # Package same function folder again
# resource "google_storage_bucket_object" "function_pubsub_archive" {
#   name   = "pubsub-function.zip"
#   bucket = google_storage_bucket.function_bucket.name
#   source = data.archive_file.function_zip.output_path
# }

# # Cloud Function triggered by Pub/Sub
# resource "google_cloudfunctions2_function" "hello_pubsub" {
#   name        = "hello-pubsub"
#   location    = var.region
#   description = "Triggered by Pub/Sub messages"

#   build_config {
#     runtime     = "python311"
#     entry_point = "hello_pubsub"
#     source {
#       storage_source {
#         bucket = google_storage_bucket.function_bucket.name
#         object = google_storage_bucket_object.function_pubsub_archive.name
#       }
#     }
#   }

#   service_config {
#     max_instance_count = 1
#     available_memory   = "128M"
#   }

#   event_trigger {
#     event_type   = "google.cloud.pubsub.topic.v1.messagePublished"
#     pubsub_topic = google_pubsub_topic.hello_topic.id
#     retry_policy = "RETRY_POLICY_RETRY"
#   }
# }

# output "pubsub_topic_name" {
#   value = google_pubsub_topic.hello_topic.name
# }

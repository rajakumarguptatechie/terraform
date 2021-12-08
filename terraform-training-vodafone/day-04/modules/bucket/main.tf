resource "google_storage_bucket" "my_bucket" {
  name     = var.name
  location = "us-central1"
  force_destroy = var.is_destroy
  lifecycle_rule {
    condition {
      age = 3
    }
    action {
      type = "Delete"
    }
  }
}

output "bucket_name" {
  value = google_storage_bucket.my_bucket.name
}

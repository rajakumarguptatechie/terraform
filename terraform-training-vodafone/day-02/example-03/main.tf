# Create GCS bucket

terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "3.5.0"
    }
  }
}

provider "google" {
  credentials = file("c:\\Software\\terraform\\terraform-training-vodafone\\project-terraform-raj-effab0ad372f.json")

  project = "project-terraform-raj"
  region  = "us-central1"
  zone    = "us-central1-c"
}

variable "terraform-test01-bucket" {
  description = "Bucket Name"
  type = string
}

resource "google_storage_bucket" "my_bucket" {
  name     = var.terraform-test01-bucket
  location = "us-central1"
  force_destroy = true
  lifecycle_rule {
    condition {
      age = 3
    }
    action {
      type = "Delete"
    }
  }
}

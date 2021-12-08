terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "3.5.0"
    }
  }
  backend "gcs" {
    bucket      = "terraform-state-bucket-001"
    prefix      = "training"
    credentials = "c:\\Software\\terraform\\terraform-training-vodafone\\project-terraform-raj-effab0ad372f.json"
  }
}

provider "google" {
  credentials = file("c:\\Software\\terraform\\terraform-training-vodafone\\project-terraform-raj-effab0ad372f.json")
  project     = "project-terraform-raj"
  region      = "us-central1"
  zone        = "us-central1-c"
}

resource "google_service_account" "service_account_007" {
  account_id  = "service-account-002"
  description = "Service Account"
}

# Create GCP IAM user and Service account

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

resource "google_service_account" "terraform-rajakumargupta" {
  account_id   = "terraform-rajakumargupta"
  description  = "Terraform SA for RajaKumarGupta"
}

resource "google_service_account_key" "mykey-01" {
  service_account_id = google_service_account.terraform-rajakumargupta.name
}

#output "terraform-rajakumargupta-key" {
#  value     = google_service_account_key.mykey-01.private_key
#  sensitive = true
#}


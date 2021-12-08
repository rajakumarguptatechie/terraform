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

  project = var.project_name
  region  = var.gcp_region["DEV"]
  zone    = var.gcp_zone
}

variable "project_name" {
  description = "Project name"
  type        = string
  default     = ""
}

variable "gcp_zone" {
  description = "GCP Zone"
  type        = string
  default     = "us-central1-c"
}

resource "google_service_account" "terraform-rajakumargupta" {
  account_id   = var.name
  description  = "Terraform SA for RajaKumarGupta"
}

resource "google_service_account_key" "mykey-01" {
  service_account_id = google_service_account.terraform-rajakumargupta.id
}

output "terraform-rajakumargupta-id" {
  value     = google_service_account.terraform-rajakumargupta.id
}

output "terraform-rajakumargupta-key" {
  value     = google_service_account_key.mykey-01.private_key
  sensitive = true
}



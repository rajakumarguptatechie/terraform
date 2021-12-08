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

# Referncing local module
module "my_bucket" {
  source     = "./bucket/"
  name       = "my_test_bucket_00001"
  is_destroy = true
}

# Referencing github module
module "service_account" {
  source     = "github.com/rajakumarguptatechie/terraform/terraform-training-vodafone/day-04/modules/service_account"
  account_id = "my-service-account-00001"
}

output "bucket_name" {
  value = module.my_bucket.bucket_name
}

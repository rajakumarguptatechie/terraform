terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
    }
    google-beta = {
      source  = "hashicorp/google-beta"
    }
  }
}

provider "google" {
  credentials = file("c:\\Software\\terraform\\terraform-training-vodafone\\project-terraform-raj-effab0ad372f.json")

  project = "project-terraform-raj"
  region  = "us-central1"
  zone    = "us-central1-c"
}

provider "google-beta" {
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

output "bucket_name" {
  value = module.my_bucket.bucket_name
}

# Referencing github module
module "service_account" {
  source     = "github.com/rajakumarguptatechie/terraform/terraform-training-vodafone/day-04/modules/service_account"
  account_id = "my-service-account-00001"
}

# Referencing Terraform registry module
module "vpc" {
  source  = "terraform-google-modules/network/google"
  #version = "3.5.0"

  project_id   = "project-terraform-raj"
  network_name = "module-example-vpc"
  routing_mode = "GLOBAL"

  subnets = [
    {
      subnet_name           = "subnet-01"
      subnet_ip             = "10.10.10.0/24"
      subnet_region         = "us-west1"
    },
    {
      subnet_name           = "subnet-02"
      subnet_ip             = "10.10.20.0/24"
      subnet_region         = "us-west1"
      subnet_private_access = "true"
      subnet_flow_logs      = "true"
      description           = "This subnet has a description"
    }
  ]
}

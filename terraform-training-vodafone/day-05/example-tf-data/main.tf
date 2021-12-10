# Use of Terraform Data

terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "3.5.0"
    }
  }
}

variable "service_account_key" {
  description = "Service Account Key"
  type        = string
  default     = "/home/rajagupta/project-terraform-raj-effab0ad372f.json"
}

provider "google" {
  credentials = file(var.service_account_key)

  project = "project-terraform-raj"
  region  = "us-central1"
  zone    = "us-central1-c"
}

resource "google_compute_network" "vpc_network" {
  name = "terraform-network"
}

data "google_compute_image" "my_image" {
  family  = "debian-9"
  project = "debian-cloud"
}

resource "google_compute_instance" "vm_instance" {
  name         = "terraform-instance"
  machine_type = "f1-micro"
  tags         = ["test", "training"]

  boot_disk {
    initialize_params {
      #image = "debian-cloud/debian-9"
      image = data.google_compute_image.my_image.self_link
    }
  }

  network_interface {
    network = google_compute_network.vpc_network.name
    access_config {
    }
  }
}

# Count and Condition example
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

resource "google_compute_network" "vpc_network" {
  name = "terraform-network"
}

variable "instance_count" {
  description = "Instance count"
  type = number
  default = 2
}

resource "google_compute_instance" "vm_instance" {
  count        = var.instance_count == 2 ? 2 : 1
  name         = "instance-${count.index}"
  machine_type = "f1-micro"
  tags         = ["test", "training"]

  boot_disk {
    initialize_params {
      #image = "debian-cloud/debian-9"
      image = "cos-cloud/cos-stable"
    }
  }

  network_interface {
    network = google_compute_network.vpc_network.name
    access_config {
    }
  }
}

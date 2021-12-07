# Dynamic block example
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

resource "google_compute_instance" "vm_instance" {
  name         = "instance-007"
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

locals {
  ports = [80, 8080]
}

resource "google_compute_firewall" "vpc_firewall" {
  name    = "test-firewall"
  network = google_compute_network.vpc_network.name

  dynamic "allow" {
    for_each = local.ports
    content {
      protocol = "tcp"
      ports = [allow.value]
    }
  }

  source_tags = ["ssh", "web"]
}

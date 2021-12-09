/*
Setting up web server using terraform
1. VM should be created
2. Configure VM for web server (provisioners)
a. Creating script to configure wer server locally at terraform folder
b. Copy this script to remote node (provisioner->file)
c. Run that script to configure web server(provisioner->remote-exec)
3. Firewall rules
*/
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

locals {
  gcp_ssh_user = "om.prakash"
  gcp_ssh_pub_key_file = "C:\\Users\\om.prakash\\.ssh\\id_rsa.pub"
  gcp_ssh_pri_key_file = "C:\\Users\\om.prakash\\.ssh\\id_rsa"
}

resource "google_compute_instance" "vm001" {
  name         = "terraform-instance"
  machine_type = "f1-micro"
  tags         = ["test", "training"]

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-9"
    }
  }

  network_interface {
    network = google_compute_network.vpc_network.name
    access_config {
    }
  }

  metadata = {
    ssh-keys = "${local.gcp_ssh_user}:${file(local.gcp_ssh_pub_key_file)}"
  }

  provisioner "file" {
    source      = "apache-setup-script.sh"
    destination = "/tmp/apache-setup-script.sh"
    connection {
      type        = "ssh"
      user        = local.gcp_ssh_user
      private_key = file(local.gcp_ssh_pri_key_file)
      host        = "${self.network_interface.0.access_config.0.nat_ip}"
    }
  }

  provisioner "remote-exec" {
    connection {
      type        = "ssh"
      user        = local.gcp_ssh_user
      private_key = file(local.gcp_ssh_pri_key_file)
      host        = "${self.network_interface.0.access_config.0.nat_ip}"
    }
    inline = [
      "chmod +x /tmp/apache-setup-script.sh",
      "/tmp/apache-setup-script.sh",
    ]
  }

  provisioner "local-exec" {
    command = "echo SetUpDone >> web-server-response.txt"
  }
}

resource "google_compute_firewall" "ssh-traffic" {
  name    = "ssh-firewall"
  network = google_compute_network.vpc_network.name

  allow {
    protocol = "tcp"
    ports    = ["22", "80"]
  }
}

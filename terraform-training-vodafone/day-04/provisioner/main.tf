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
  gcp_ssh_user = "mykey"
  gcp_ssh_pub_key_file = "c:\\Software\\terraform\\terraform-training-vodafone\\gcp_ssh_pub_key_file.txt"
  gcp_ssh_pri_key_file = "c:\\Software\\terraform\\terraform-training-vodafone\\gcp_ssh_pri_key_file.txt"
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
      user        = "mykey"
      private_key = file(local.gcp_ssh_pri_key_file)
      host        = "${self.network_interface.0.access_config.0.nat_ip}"
    }
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/apache-setup-script.sh",
      "/tmp/script.sh",
    ]
  }

  provisioner "local-exec" {
    command = "wget http://${self.network_interface.0.network_ip} >> web-server-response.txt"
  }
}

output "web-server-url" {
  value = "http://${google_compute_instance.vm001.network_interface.0.access_config.0.nat_ip}"
}

resource "google_compute_firewall" "ssh-traffic" {
  name    = "ssh-firewall"
  network = google_compute_network.vpc_network.name

  allow {
    protocol = "tcp"
    ports    = ["22", "80"]
  }
}

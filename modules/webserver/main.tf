# Deploy webserver in GCP

provider "google" {
  project = var.gcp_project
  region  = var.gcp_region
  zone    = var.gcp_zone
}

resource "google_compute_network" "gcp_net" {
  name = "${var.environment_name}-vpc"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "gcp_subnet" {
  name          = "${var.environment_name}-subnet"
  ip_cidr_range = var.subnet_block
  region        = var.gcp_region
  network       = google_compute_network.gcp_net.id
}

resource "google_compute_firewall" "gcp_fw_vpc" {
  name    = "${var.environment_name}-fw-vpc"
  network = google_compute_network.gcp_net.name

  allow {
    protocol = "all"
  }

  source_ranges = [var.cidr_block]
}

resource "google_compute_firewall" "gcp_fw_ext" {
  name    = "${var.environment_name}-fw-ext"
  network = google_compute_network.gcp_net.name

  allow {
    protocol = "tcp"
    ports    = ["22", "80", "443"]
  }

  source_ranges = ["0.0.0.0/0"]
}

resource "google_compute_instance" "ubuntu" {
  count        = var.node_count
  name         = "${var.environment_name}-node-${count.index}"
  machine_type = var.machine_type
  zone         = var.gcp_zone
  project      = var.gcp_project
  depends_on   = [google_compute_subnetwork.gcp_subnet]

  boot_disk {
    initialize_params {
      size = var.root_volume_size
      type = var.root_volume_type
      image = "ubuntu-os-cloud/ubuntu-2004-lts"
    }
  }

  network_interface {
    subnetwork = google_compute_subnetwork.gcp_subnet.name
    subnetwork_project = var.gcp_project
    access_config {}
  }

  metadata = {
    ssh-keys = "ubuntu:${var.ssh_key}"
  }

  service_account {
    email = var.gcp_service_account_email
    scopes = ["cloud-platform"]
  }

  provisioner "remote-exec" {
    inline = [
      "sudo apt update -y",
      "sudo apt install -y nginx",
      "echo Hello_World > /var/www/html/index.html",
    ]
    connection {
      host        = self.network_interface.0.access_config.0.nat_ip
      type        = "ssh"
      user        = "ubuntu"
      private_key = var.ssh_key
    }
  }
}

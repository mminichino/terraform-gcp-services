# Variables

variable "gcp_region" {
  description = "GCP region"
}

variable "gcp_zone" {
  description = "GCP zone"
}

variable "gcp_project" {
  description = "GCP project"
}

variable "gcp_service_account_email" {
  description = "GCP service account email"
}

variable "environment_name" {
  description = "Environment name"
}

variable "ssh_key" {
  description = "Admin SSH key"
}

variable "ssh_private_key" {
  description = "Admin SSH private key"
}

variable "cidr_block" {
  description = "VPC CIDR"
}

variable "subnet_block" {
  description = "Subnet CIDR"
}

variable "machine_type" {
  description = "Machine Type"
  default     = "e2-micro"
}

variable "root_volume_size" {
  description = "The root volume size"
  default     = "50"
}

variable "root_volume_type" {
  description = "The root volume type"
  default     = "pd-ssd"
}

variable "node_count" {
  description = "Node count"
  default     = 3
}

output "gcp-private" {
  value = [google_compute_instance.ubuntu.*.network_interface.0.network_ip]
}

output "gcp-public" {
  value = [google_compute_instance.ubuntu.*.network_interface.0.access_config.0.nat_ip]
}

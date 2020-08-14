resource "google_compute_network" "network" {
  name                    = "${var.project_name}-network"
  auto_create_subnetworks = var.auto_create_subnetworks
  project                 = var.project_id
  routing_mode            = var.routing_mode
}

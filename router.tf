resource "google_compute_router" "vpc_router" {
  project = var.project_id
  name    = "${var.project_name}-router"
  region  = var.region
  network = google_compute_network.network.name
}

locals {
  nat_ips_length                 = length(var.nat_ips)
  default_nat_ip_allocate_option = local.nat_ips_length > 0 ? "MANUAL_ONLY" : "AUTO_ONLY"
  nat_ip_allocate_option         = var.nat_ip_allocate_option ? var.nat_ip_allocate_option : local.default_nat_ip_allocate_option
}

resource "google_compute_address" "address" {
  count        = var.create_manual_ip ? 1 : 0
  name         = "nat-manual-ip"
  address_type = "EXTERNAL"
  region       = google_compute_subnetwork.subnetwork.region
}

resource "google_compute_router_nat" "vpc_nat" {
  name = "${var.project_name}-nat"

  project                            = var.project_id
  region                             = var.region
  router                             = google_compute_router.vpc_router.name
  nat_ips                            = local.nat_ip_allocate_option == "AUTO_ONLY" ? var.nat_ips : google_compute_address.address.*.self_link
  nat_ip_allocate_option             = local.nat_ip_allocate_option
  source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES"

}

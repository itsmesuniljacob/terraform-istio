# This file handles the creation of subnetwork for cloud GCP.
resource "google_compute_subnetwork" "subnetwork" {
  project = var.project_id
  name          = "${var.project_name}-subnetwork"
  ip_cidr_range = var.subnet_cidr
  # Conditionally opting regions for subnet, defaults to th region declared in provider.
  region  = var.subnet_region == "" ? var.region : var.subnet_region
  network = google_compute_network.network.self_link

  # Following block dynamically generates the block log_config if it is defined.
  dynamic "log_config" {
    for_each = var.log_config == null ? [] : [var.log_config]
    content {
      aggregation_interval = log_config.value.subnet_logs_interval
      flow_sampling        = log_config.value.subnet_logs_sampling
      # metadata was not parameterized because following is the only value that can be passed.
      metadata = "INCLUDE_ALL_METADATA"
    }
  }

  # Following block dynamically generates the list of secondary_ip_range block if it is defined.
  dynamic "secondary_ip_range" {
    for_each = [for sec in var.secondary_ip_range : {
      range_name    = sec.range_name
      ip_cidr_range = sec.ip_cidr_range
    }]
    content {
      range_name    = secondary_ip_range.value.range_name
      ip_cidr_range = secondary_ip_range.value.ip_cidr_range
    }
  }

  depends_on = [google_compute_network.network]
}

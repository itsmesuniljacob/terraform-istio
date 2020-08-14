# We use this data provider to expose an access token for communicating with the GKE cluster.
data "google_client_config" "default" {}

provider "kubernetes" {
  alias                  = "gke"
  version                = "1.9"
  load_config_file       = false
  host                   = google_container_cluster.gke_cluster.endpoint
  token                  = data.google_client_config.default.access_token
  cluster_ca_certificate = google_container_cluster.gke_cluster.master_auth[0].client_certificate
}

## Private & Regional Cluster
resource "google_container_cluster" "gke_cluster" {
  name               = "istio-test-cluster"
  description        = "test cluster"
  project            = var.project_id
  location           = var.region
  node_version       = var.gke_version
  min_master_version = var.gke_version
  monitoring_service = "monitoring.googleapis.com/kubernetes"
  logging_service    = "logging.googleapis.com/kubernetes"
  network            = google_compute_network.network.self_link
  subnetwork         = google_compute_subnetwork.subnetwork.self_link
  provider           = google-beta
  initial_node_count = var.gke_initial_node_count
  default_max_pods_per_node = var.default_max_pods_per_node
  remove_default_node_pool  = var.remove_default_node_pool

  enable_kubernetes_alpha = lookup(var.master, "enable_kubernetes_alpha", false)
  enable_legacy_abac      = lookup(var.master, "enable_legacy_abac", false)
  enable_shielded_nodes   = lookup(var.master, "enable_shielded_nodes", false)

  private_cluster_config {
    enable_private_nodes   = true
    master_ipv4_cidr_block = var.master_ipv4_cidr_block
    enable_private_endpoint = false
  }

  ip_allocation_policy {
    cluster_secondary_range_name  = "subnet-secondary-01"
    services_secondary_range_name = "subnet-secondary-02"
  }

  resource_labels = {
    project     = var.project_name
    environment = var.environment
  }

  addons_config {
    horizontal_pod_autoscaling {
      disabled = lookup(var.master, "disable_horizontal_pod_autoscaling", false)
    }

    http_load_balancing {
      disabled = lookup(var.master, "disable_http_load_balancing", false)
    }

//    kubernetes_dashboard {
//      disabled = lookup(var.master, "disable_kubernetes_dashboard", false)
//    }

    network_policy_config {
      disabled = lookup(var.master, "disable_network_policy_config", true)
    }

    istio_config {
      disabled = lookup(var.master, "disable_istio_config", true)
    }
  }

  # Support to encrypt the etcd data in GKE cluster
  # database_encryption {
  #   state    = var.gke_encryption_state
  #   key_name = google_kms_crypto_key.crypto_key.id
  # }

  master_authorized_networks_config {
    cidr_blocks {
      cidr_block   = "0.0.0.0/0"
      display_name = "Disabled"
    }
  }

  lifecycle {
    ignore_changes = [node_version, resource_labels, initial_node_count, node_pool]
  }

  maintenance_policy {
    daily_maintenance_window {
      start_time = var.daily_maintenance_window_start
    }
  }
}

resource "google_container_node_pool" "gke_cluster-nodepool" {
  project = var.project_id
  count             = length(var.node_pool)
  name              = "${var.project_name}-node-pool"
  location          = var.region
  cluster           = google_container_cluster.gke_cluster.name
  node_count        = lookup(var.node_pool[count.index], "node_count", 1)
  provider          = google-beta
  max_pods_per_node = var.max_pods_per_node

  node_config {
    oauth_scopes    = tolist(var.oauth_scopes)
    disk_size_gb    = lookup(var.node_pool[count.index], "disk_size_gb", 10)
    disk_type       = lookup(var.node_pool[count.index], "disk_type", "pd-standard")
    image_type      = lookup(var.node_pool[count.index], "image", "COS")
    local_ssd_count = lookup(var.node_pool[count.index], "local_ssd_count", 1)
    machine_type    = lookup(var.node_pool[count.index], "machine_type", "n1-standard-1")
    preemptible  = var.gke_preemptible

    labels = {
      project     = var.project_name
      environment = var.environment

    }

    tags = [var.environment]
  }

  management {
    auto_repair  = var.auto_repair
    auto_upgrade = var.auto_upgrade
  }

  autoscaling {
    min_node_count = var.gke_auto_min_count
    max_node_count = var.gke_auto_max_count
  }

  lifecycle {
    ignore_changes = [node_count, autoscaling, node_config[0].labels]
  }
}

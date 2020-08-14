### Author : BootLabsTech Pvt Ltd.
### Description: Terraform GCP generic variables file

region             = "us-central1"
zone               = "us-central1-c"
project_name       = "core-env-project"
project_id         = "core-env-project"
subnet_cidr        = "10.0.0.0/16"
log_config         = { subnet_logs_interval = "INTERVAL_5_MIN", subnet_logs_sampling = 0.5 }
secondary_ip_range = [{ range_name = "subnet-secondary-01", ip_cidr_range = "10.1.0.0/16" }, { range_name = "subnet-secondary-02", ip_cidr_range = "10.2.0.0/16" }]

# Variables to enable Shared VPC
host_project     = "bootlabs-internal"
service_projects = ["rabbit1", "rabbit2-275309"]

# Variables for firewall
firewall_allow_rules = [{ protocol = "tcp", ports = ["22", "80", "8080"] }, /*{ protocol = "icmp", ports = [] }*/]
# Uncomment the following line to enable deny_rules. At once only one set of rules can be applied either allow or deny.
# firewall_deny_rules  = [{ protocol = "tcp", ports = ["80", "8080"] }]

# Variable for GCE instance group
compute_name            = "bootlabs-webserver"
compute_machine_type    = "f1-micro"
compute_image           = "debian-cloud/debian-9"
compute_tags            = []
compute_ssh_keys        = {}
network                 = "bootlabs-internal-network"
compute_subnetwork      = "bootlabs-internal-subnetwork"

# GKE variables
gke_version                     = "1.15"
gke_preemptible                 = true
gke_encryption_state            = "ENCRYPTED"
gke_encryption_key              = ""

gke_instance_type          = "n1-standard-2"
gke_auto_min_count         = 1
gke_auto_max_count         = 5
gke_initial_node_count     = 1
gke_node_pool_disk_size    = 100
max_pods_per_node      = 64


oauth_scopes                    = [
    "https://www.googleapis.com/auth/compute",
    "https://www.googleapis.com/auth/cloud-platform",
    "https://www.googleapis.com/auth/devstorage.read_only",
    "https://www.googleapis.com/auth/taskqueue",
    "https://www.googleapis.com/auth/sqlservice.admin",
    "https://www.googleapis.com/auth/monitoring.write",
    "https://www.googleapis.com/auth/servicecontrol",
    "https://www.googleapis.com/auth/service.management.readonly",
    "https://www.googleapis.com/auth/trace.append",
    "https://www.googleapis.com/auth/monitoring",
    "https://www.googleapis.com/auth/logging.write",
    "https://www.googleapis.com/auth/pubsub",
    "https://www.googleapis.com/auth/cloud_debugger",
]

daily_maintenance_window_start  = "03:00"

general = {
    name = "mycluster"
    env  = "prod"
    location = "us-central1-a"
}

# default_node_pool = {
#   node_count = 3
#   remove     = false
# }

node_pool = [{
    disk_size_gb   = "20"
    node_count     = "1"
    min_node_count = "2"
    max_node_count = "4"
  }
  # {
  #   disk_size_gb   = "30"
  #   node_count     = "2"
  #   min_node_count = "1"
  #   max_node_count = "3"
  # },
]

remove_default_node_pool = true
# GKE Variable - END

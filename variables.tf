### Author : BootLabsTech Pvt Ltd.
### Description: Terraform GCP generic variables file(used for provider configuration and root level files)

### The variables for provider file and for generic use
variable "region" {
  description = "The region to manage gcp resources"
  type        = string
}

variable "project_id" {
  description = "The ID of the project where this VPC will be created"
}

variable "zone" {
  description = "The zone to manage gcp resources"
  type        = string
}

variable "project_name" {
  description = "The project name"
  type        = string
}

variable "routing_mode" {
  type        = string
  default     = "GLOBAL"
  description = "The network routing mode (default 'GLOBAL')"
}

variable "auto_create_subnetworks" {
  type        = bool
  description = "When set to true, the network is created in 'auto subnet mode' and it will create a subnet for each region automatically across the 10.128.0.0/9 address range. When set to false, the network is created in 'custom subnet mode' so the user can explicitly connect subnetwork resources."
  default     = false
}

# Variables required for subnet creation.
variable "subnet_cidr" {
  description = "The range of internal addresses that would be owned by the subnetwork"
  type        = string
}

variable "subnet_region" {
  description = "Define the region in which the subnet to be created, if not specified it defaults to the region from provider"
  type        = string
  default     = ""
}

variable "secondary_ip_range" {
  description = "Define this if secondary IP ranges for subnets required"
  type = list(object({
    range_name    = string
    ip_cidr_range = string
  }))
  default = []
}

variable "log_config" {
  description = "Define this if logging of subnets required on stackdriver"
  type = object({
    subnet_logs_interval = string
    subnet_logs_sampling = number
  })
  default = null
}

####### Definitions for Manual and Auto NAT configuration #########
variable "nat_ips" {
  description = "List of self_links of external IPs. Changing this forces a new NAT to be created."
  type        = list(string)
  default     = []
}

variable "nat_ip_allocate_option" {
  description = "Value inferred based on nat_ips. If present set to MANUAL_ONLY, otherwise AUTO_ONLY."
  default     = "false"
}

# Enable the belwow flag for manual creation of IP
variable "create_manual_ip" {
  description = "Definition to create manual IP"
  type        = bool
  default     = false
}

# Variables to enable Shared VPC
variable "host_project" {
  type        = string
  default     = ""
  description = "The project the subnetwork belongs to."
}

variable "service_projects" {
  type    = list
  default = []
}

# Variables required for firewall creation.
variable "firewall_allow_rules" {
  description = "Define this if list of allow rules has to be specified to firewall"
  type = list(object({
    protocol = string
    ports    = list(string)
  }))
  default = []
}

variable "firewall_deny_rules" {
  description = "Define this if list of deny rules has to be specified to firewall"
  type = list(object({
    protocol = string
    ports    = list(string)
  }))
  default = []
}

variable "firewall_name" {
  description = "Specify a name to the firewall that has to be created"
  default     = ""
}

variable "firewall_project" {
  description = "The ID of the project where the firewall needs to be created"
  default     = ""
}

variable "source_ranges_for_firewall" {
  description = "Range of IP addresses to which the firewall has to be applied, specify it in CIDR format"
  type        = list(string)
  default     = []
}

variable "destination_ranges_for_firewall" {
  description = "Range of destination IP addresses to which the firewall has to be applied, specify it in CIDR format"
  type        = list(string)
  default     = []
}

variable "firewall_source_tags" {
  description = "List of source tags to which firewall has to be applied"
  type        = list(string)
  default     = []
}

variable "firewall_target_tags" {
  description = "List of target tags to which firewall has to be applied"
  type        = list(string)
  default     = []
}

variable "target_service_accounts" {
  description = "List of service accounts to which firewall has to be applied, this conflicts with firewall_target_tags"
  type        = list
  default     = []
}

variable "source_service_accounts" {
  description = "The firewall will apply only to traffic originating from an instance with a service account in this list, this conflicts with firewall_source_tags"
  type        = list
  default     = []
}

variable "firewall_direction" {
  description = "Direction of traffic to which this firewall applies"
  type        = string
  default     = "INGRESS"
}

# Variables required for IP creation.
variable "global" {
  description = "The scope in which the address should live. If set to true, the IP address will be globally scoped. Defaults to false, i.e. regionally scoped. When set to true, do not provide a subnetwork."
  default     = false
}

variable "names" {
  description = "A list of IP address resource names to create.  This is the GCP resource name and not the associated hostname of the IP address.  Existing resource names may be found with `gcloud compute addresses list"
  type        = list(string)
  default     = [
    "bootlabs-external-001-ip"
  ]
}

variable "addresses" {
  description = "A list of IP addresses to create.  GCP will reserve unreserved addresses if given the value \"\".  If multiple names are given the default value is sufficient to have multiple addresses automatically picked for each name."
  type        = list(string)
  default     = [""]
}

variable "address_type" {
  type        = string
  description = "The type of address to reserve, either \"INTERNAL\" or \"EXTERNAL\". If unspecified, defaults to \"EXTERNAL\"."
  default     = "EXTERNAL"
}

# subnetwork = "projects/gcp-network/regions/us-west1/subnetworks/bootlabs-internal-subnetwork"
variable "subnetwork" {
  type        = string
  description = "The subnet containing the address.  For EXTERNAL addresses use the empty string."
  default     = ""
}

# Variables required for Compute Engine
variable "compute_name" {
  type        = string
  description = "A unique name for the resource, required by GCE"
}

variable "compute_machine_type" {
  type        = string
  default     = "f1-micro"
  description = "The machine type to create"
}

variable "compute_image" {
  type        = string
  description = "The image from which to initialize this disk"
}

variable "compute_tags" {
  type        = list
  description = "Tags to attach to the instance"
}

variable "compute_ssh_keys" {
  type =   map
}

variable "compute_preemptible" {
  type        = bool
  default     = false
  description = "Allows instance to be preempted"
}

variable "compute_automatic_restart" {
  type        = bool
  default     = true
  description = "Specifies whether the instance should be automatically restarted if it is terminated by Compute Engine (not terminated by a user)."
}

variable "network" {
  description = "Name of the network to deploy instances to."
  default     = "default"
}

variable "compute_subnetwork" {
  type        = string
  description = "The subnetwork to deploy to"
  default     = "default"
}

variable "compute_update_ploicy" {
  type        = map
  description = "The update policy for the managed instance group."
  default     = {
    type                  = "PROACTIVE"
    minimal_action        = "REPLACE"
    max_surge_percent     = 20
    max_unavailable_fixed  = 1
    min_ready_sec         = 50
  }
}

# GKE

variable "general" {
  type        = map(string)
  description = "Global parameters"
}

variable "max_pods_per_node" {
  type        = string
  description = "Number of max pods per node"
}

variable "master_ipv4_cidr_block" {
  type        = string
  description = "IPv4 CIDR Block for Master Nodes"
  default     = "10.103.4.0/28"
}


variable "gke_initial_node_count" {
  description = "The initial node count for the default node pool"
}

variable "daily_maintenance_window_start" {
  type        = string
  description = "Daily maintenance window start time"
}

variable "gke_node_pool_disk_size" {
  description = "Disk Size for GKE Nodes"
}

variable "gke_preemptible" {
  description = "GKE Preemtible nodes"
}

variable "gke_auto_min_count" {
  description = "The minimum number of VMs in the pool"
}

variable "gke_auto_max_count" {
  description = "The maximum number of VMs in the pool"
}

variable "gke_version" {
  type        = string
  description = "The kubernetes version to use"
}

variable "gke_instance_type" {
  type        = string
  description = "The worker instance type"
}

variable "oauth_scopes" {
  description = "oauth scopes for gke cluster"
  type        = list(string)
}

variable "gke_encryption_state" {
  type        = string
  description = "gke cluster encryption state"
}

variable "gke_encryption_key" {
  type        = string
  description = "gke cluster encryption key"
}

variable "disable_istio_addons" {
  type        = string
  description = "Disable istio addons on GKE"
  default     = true
}

variable "default_max_pods_per_node" {
  description = "The maximum number of pods to schedule per node"
  default     = 110
}

variable "environment" {
  default = "prod"
}

variable "description" {
  default = "GKE node"
}

variable "remove_default_node_pool" {
  type        = bool
  default     = true
}

# Parameters authorized:
# node_count (default: 3)
# machine_type (default: n1-standard-1)
# disk_size_gb (default: 10)
# preemptible (default: false)
# local_ssd_count (default: 0)
# oauth_scopes (default: https://www.googleapis.com/auth/compute,https://www.googleapis.com/auth/devstorage.read_only,https://www.googleapis.com/auth/logging.write,https://www.googleapis.com/auth/monitoring)
# min_node_count (default: 1)
# max_node_count (default: 3)
# auto_repair (default: true)
# auto_upgrade (default: true)
# metadata (default: {})
variable "node_pool" {
  type        = list(map(string))
  default     = []
  description = "Node pool setting to create"
}

# Parameters authorized:
# network (default: default)
# subnetwork (default: default)
# disable_horizontal_pod_autoscaling (default: false)
# disable_http_load_balancing (default: false)
# disable_kubernetes_dashboard (default: false)
# disable_network_policy_config (default: true)
# enable_kubernetes_alpha (default: false)
# enable_legacy_abac (default: false)
# maintenance_window (default: 4:30)
# version (default: Data resource)
# monitoring_service (default: none)
# logging_service (default: logging.googleapis.com)
variable "master" {
  type        = map(string)
  default     = {}
  description = "Kubernetes master parameters to initialize"
}

variable "auto_repair" {
  type    = bool
  default = true
  description = "Whether the nodes will be automatically repaired"
}

variable "auto_upgrade" {
  type    = bool
  default = true
  description = "Whether the nodes will be automatically upgraded."
}

# GKE end

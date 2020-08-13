provider "google" {
  version = "2.19.0"
  project = var.project_id
  region  = var.region
}

provider "google-beta" {
  version = "3.21.0"
  project = var.project_id
  region  = var.region
}
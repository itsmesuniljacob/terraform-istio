provider "google" {
  version = "2.19.0"
  region  = var.region
  zone    = var.zone
}
provider "google-beta" {
  version = "3.21.0"
  region  = var.region
  zone    = var.zone
}

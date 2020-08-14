# resource "random_id" "id" {
#   byte_length = 4
#   prefix      = var.project_name
# }
#
# resource "google_kms_key_ring" "key_ring" {
#   name     = random_id.id.hex
#   project  = var.project_id
#   location = var.region
# }
#
# resource "google_kms_crypto_key" "crypto_key" {
#   name            = random_id.id.hex
#   key_ring        = google_kms_key_ring.key_ring.self_link
#   rotation_period = "100000s"
#
#   lifecycle {
#     prevent_destroy = false
#   }
# }

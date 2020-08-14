resource "null_resource" "istio_install" {
  # provider = kubernetes.gke
  # triggers = {
  # always_run = "${timestamp()}"
  # }

  provisioner "local-exec" {
    command = "../istio-1.6.7/bin/istioctl manifest apply -f istio-profile.yaml;sleep 60"
  }

  depends_on = [google_container_cluster.gke_cluster]
}

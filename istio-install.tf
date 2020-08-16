resource "null_resource" "istio_install" {
  # provider = kubernetes.gke
  triggers = {
    k8s_yaml_contents = file("${path.module}/istio-profile.yaml")
  }

  provisioner "local-exec" {
    # command = "../istio-1.6.7/bin/istioctl manifest apply -f ${file("${path.module}/istio-profile.yaml")};sleep 60"
    command = <<-EOT
      gcloud container clusters get-credentials istio-test-cluster --region us-central1 --project core-env-project;
      ../istio-1.6.7/bin/istioctl manifest apply -f istio-profile.yaml;
      sleep 120
    EOT 
  }
  depends_on = [google_container_cluster.gke_cluster]
}

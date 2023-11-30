module "gcp-network" {
  source     = "terraform-google-modules/network/google"
  version    = "6.0.1"
  project_id = var.k8s-standard-architecture
  network_name = "${}-${}"
  subnets = [

  ]
}

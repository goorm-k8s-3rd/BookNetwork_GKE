#GKE 클러스터에 대한 인증을 구성한다.

module "gke_auth" {
  source               = "terraform-google-modules/kubernetes-engine/google//modules/auth"
  version              = "29.0.0"
  project_id           = var.project_id
  location             = module.gke.location
  cluster_name         = module.gke.name
  use_private_endpoint = true
  depends_on           = [module.gke]
}

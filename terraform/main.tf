data "google_client_config" "default" {}

provider "kubernetes" {
  host                   = "https://${module.gke.endpoint}"
  token                  = data.google_client_config.default.access_token
  cluster_ca_certificate = base64decode(module.gke.ca_certificate)
}

resource "google_storage_bucket" "default" {
  name          = "k8s-standard-bucket-tfstate"
  force_destroy = false
  location      = "ASIA-NORTHEAST3"
  storage_class = "STANDARD"
  versioning {
    enabled = true
  }
  encryption {
    default_kms_key_name = google_kms_crypto_key.terraform_state_bucket.id
  }
  depends_on = [
    google_project_iam_member.default
  ]
}

module "gke" {
  source                     = "terraform-google-modules/kubernetes-engine/google//modules/private-cluster"
  project_id                 = var.project_id
  name                       = var.cluster_name
  region                     = var.region
  zones                      = var.zones
  network                    = module.vpc.network_name
  subnetwork                 = module.vpc.subnet_name
  ip_range_pods              = var.ip_range_pods_name
  ip_range_services          = var.ip_range_services_name
  http_load_balancing        = true
  network_policy             = true
  horizontal_pod_autoscaling = true
  filestore_csi_driver       = false
  enable_private_endpoint    = true
  enable_private_nodes       = true
  master_ipv4_cidr_block     = "10.0.0.0/28"

  node_pools = [
    {
      name            = "default-node-pool"
      machine_type    = "e2-standard-4"
      node_locations  = "asia-northeast3-b, asia-northeast3-c"
      min_count       = 2
      max_count       = 5
      disk_size_gb    = 30
      spot            = false
      image_type      = "COS_CONTAINERD"
      disk_type       = "pd-standard"
      logging_variant = "DEFAULT"
      auto_repair     = true
      auto_upgrade    = true
      service_account = "${var.cluster_name}@${var.project_id}.iam.gserviceaccount.com"
    }
  ]

  node_pools_oauth_scopes = {
    all = [
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
      "https://www.googleapis.com/auth/trace.append",
      "https://www.googleapis.com/auth/service.management.readonly",
      "https://www.googleapis.com/auth/devstorage.read_only",
      "https://www.googleapis.com/auth/servicecontrol"
    ]
  }

  node_pools_labels = {
    all = {}
    default-node-pool = {
      default-node-pool = true
    }
  }

  node_pools_metadata = {
    all = {}
    default-node-pool = {
      #노드가 종료될 때, kubectl drain 명령어를 사용하여 파드를 안전하게 제거하고 필요하다면 다른 노드로 재스케줄링 되도록 하는 스크립트를 실행한다.
      shutdown-script                 = "kubectl --kubeconfig=/var/lib/kubelet/kubeconfig drain --force=true --ignore-daemonsets=true --delete-local-data \"$HOSTNAME\""
      node-pool-metadata-custom-value = "default-node-pool"
    }
  }

  node_pools_taint = {
    all = []

    default-node-pool = [
      {
        key    = "default-node-pool"
        value  = true
        effect = "PREFER_NO_SCHEDULE"
      }
    ]
  }

  node_pools_tags = {
    all = {}

    default-node-pool = [
      "default-node-pool",
    ]
  }

  depends_on = [module.vpc]
}

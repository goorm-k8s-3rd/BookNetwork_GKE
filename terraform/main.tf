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

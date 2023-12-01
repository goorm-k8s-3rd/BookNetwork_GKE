# backend.tf를 통해 Terraform의 state를 원격 저장소에 저장하도록 설정할 수 있다.
# GCP를 사용할 것이므로, GCS(Google Cloud Storage) 버킷으로 설정해 준다. 혹은 Terraform Cloud를 사용할 수도 있다.

terraform {
  backend "gcs" {
    bucket = "k8s-standard-bucket-tfstate"
    prefix = "terraform/state"
  }
}


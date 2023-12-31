terraform {
  # provider 파일을 통해 Terraform은 클라우드 공급자, SaaS 공급자 및 기타 API와 상호작용할 수 있다. 
  # Terraform이 프로젝트에서 사용할 특정 프로바이더와 그들의 버전을 정의하여, 구성의 일관성과 호환성을 보장한다.

  required_version = ">= 1.6" # 최소 Terraform 버전을 1.6.0 이상으로 지정
  required_providers {
    google = {
      source  = "hashicorp/google" # Google 프로바이더의 출처를 HashiCorp 레지스트리에서 "hashicorp/google"으로 지정
      version = "~> 5.7.0"         # Google 프로바이더의 버전을 5.7.0으로 지정하며, 호환 가능한 마이너 업데이트는 허용
    }
    local = {
      source  = "hashicorp/local"
      version = "2.4.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.24.0"
    }
  }
}

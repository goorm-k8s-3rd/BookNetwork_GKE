# Common variables

variable "project_id" {
  type        = string
  description = "project id"
  default     = ""
}

variable "region" {
  type        = string
  description = "cluster region"
  default     = ""
}

variable "env_name" {
  type        = string
  description = "The environment for the GKE cluster"
  default     = "dev"
}

# Cluster variables


variable "cluster_name" {
  type        = string
  description = "name of cluster"
  default     = ""
}

variable "network" {
  type        = string
  description = "The VPC network"
  default     = "gke-network"
}


# 변수를 정의한다. 정의한 변수에 값을 주입하기 위해서는 terraform.tfvars 파일을 이용한다.

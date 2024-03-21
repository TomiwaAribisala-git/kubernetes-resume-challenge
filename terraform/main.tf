terraform {
  cloud {
    organization = "tomiwa-terraform-bootcamp-2023"

    workspaces {
      name = "ecommerce-app-cluster"
    }
  }
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "5.41.0"
    }
  }
}

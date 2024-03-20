terraform {
  cloud {
    organization = "tomiwa-terraform-bootcamp-2023"

    workspaces {
      name = "eks-cluster"
    }
  }
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "5.41.0"
    }
  }
}

locals {
  name   = "eks-desired-size-hack"
  desired_size = 4
}

resource "null_resource" "update_desired_size" {
  triggers = {
    desired_size = local.desired_size
  }

  provisioner "local-exec" {
    interpreter = ["/bin/bash", "-c"]
    command = <<-EOT
      aws eks update-nodegroup-config \
        --cluster-name ${module.eks.cluster_name} \
        --nodegroup-name ${element(split(":", module.eks.eks_managed_node_groups["example"].node_group_id), 1)} \
        --scaling-config desiredSize=${local.desired_size}
    EOT
  }
}

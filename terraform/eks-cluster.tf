module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 20.0"

  cluster_name    = "ecommerce-app-cluster"
  cluster_version = "1.29"

  cluster_endpoint_public_access  = true

  cluster_addons = {
    coredns = {
      most_recent = true
    }
    kube-proxy = {
      most_recent = true
    }
    vpc-cni = {
      most_recent = true
    }
  }

  vpc_id                   = module.ecommerce-app-vpc.vpc_id
  subnet_ids               = module.ecommerce-app-vpc.private_subnets

  # EKS Managed Node Group(s)
  eks_managed_node_group_defaults = {
    instance_types = ["t3.micro"]
  }

  eks_managed_node_groups = {
    example = {
      min_size     = 2
      max_size     = 3
      desired_size = 2
    }
  }

  # Cluster access entry
  # To add the current caller identity as an administrator
  enable_cluster_creator_admin_permissions = true

  tags = {
    environment = "ecommerce-app"
  }
}

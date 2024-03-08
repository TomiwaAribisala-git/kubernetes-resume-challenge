module "ecommerce-app-vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "ecommerce-app-vpc"
  cidr = var.vpc_cidr_block

  azs             = ["eu-north-1a", "eu-north-1b", "eu-north-1c"]
  private_subnets = var.private_subnet_cidr_blocks
  public_subnets  = var.public_subnet_cidr_blocks

  enable_nat_gateway = true
  enable_vpn_gateway = true

  tags = {
    Environment = "ecommerce-app-vpc"
  }
}
module "vpc" {
  source = "../../modules/vpc"

  env                  = var.env
  vpc_cidr             = var.vpc_cidr
  public_subnet_cidrs  = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
  data_subnet_cidrs    = var.data_subnet_cidrs
}

module "security_groups" {
source = "../../modules/security-groups"

vpc_id = module.vpc.vpc_id
env = var.env 
}

module "eks" {
  source = "../../modules/eks"

  env                     = var.env
  vpc_id                  = module.vpc.vpc_id
  private_subnet_ids      = module.vpc.private_subnet_ids
  eks_public_access_cidrs = var.eks_public_access_cidrs
}

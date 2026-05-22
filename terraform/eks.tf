module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 17.0"

  cluster_name    = "my-cluster"
  cluster_version = "1.27"

  # Cluster endpoint access
  cluster_endpoint_private_access = true
  cluster_endpoint_public_access  = true

  # Cluster addons
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

  # VPC and networking
  vpc_id     = module.vpc.vpc_id
  subnet_ids = concat(module.vpc.private_subnets, module.vpc.public_subnets)

  # EKS Managed Node Group(s)
  eks_managed_node_groups = {
    green = {
      name           = "green-node-group"
      use_name_prefix = true
      
      min_size     = 1
      max_size     = 3
      desired_size = 1

      instance_types = ["t3.large"]
      capacity_type  = "SPOT"

      disk_size = 20

      labels = {
        Environment = "dev"
        NodeGroup   = "green"
      }

      tags = {
        "NodeGroup" = "green"
      }
    }
  }

  # Cluster tags
  tags = {
    Environment = "dev"
    Terraform   = "true"
  }
}

# Outputs
output "cluster_id" {
  description = "The ID/name of the EKS cluster"
  value       = module.eks.cluster_id
}

output "cluster_arn" {
  description = "The Amazon Resource Name (ARN) of the cluster"
  value       = module.eks.cluster_arn
}

output "cluster_endpoint" {
  description = "Endpoint for EKS control plane"
  value       = module.eks.cluster_endpoint
}

output "cluster_version" {
  description = "The Kubernetes server version for the cluster"
  value       = module.eks.cluster_version
}

output "cluster_security_group_id" {
  description = "Security group ID attached to the EKS cluster"
  value       = module.eks.cluster_security_group_id
}
# VPC module
# KMS module
# Kubernetes components - https://kubernetes.io/docs/concepts/overview/components/#:~:text=kube%2Dproxy%20is%20a%20network,or%20outside%20of%20your%20cluster.
# Add-ons
    # coredns - https://docs.aws.amazon.com/eks/latest/userguide/managing-coredns.html
    # vpc-cni - https://docs.amazonaws.cn/en_us/eks/latest/userguide/cni-iam-role.html
# Node Groups & Fargate configuration 
    # Taints and tolerations are a mechanism that allows you to ensure that pods are not placed on inappropriate nodes. Taints are added to nodes, while tolerations are defined in the pod specification
    # For example, most Kubernetes distributions will automatically taint the master nodes so that one of the pods that manages the control plane is scheduled onto them and not any other data plane pods deployed by users
    # kubectl taint nodes nodename activeEnv=green:NoSchedule
        # tolerations:
        # - effect: NoSchedule
        #   key: activeEnv
        #   operator: Equal
        #   value: green
# Update kubeconfig to connect to the EKS cluster
   # aws eks update-kubeconfig --name masterclass-cluster --region eu-west-2 --kubeconfig ~/.kube/config --profile masterclass
   # kubectl cheat sheet - https://kubernetes.io/docs/reference/kubectl/cheatsheet/#kubectl-context-and-configuration
   # kubectl config get-contexts 
   # kubectl config use-context arn:aws:eks:eu-west-2:832611670348:cluster/masterclass-cluster

############# Provider & Backend #############
########################################

provider "aws" {
  region = "eu-west-2"
}

terraform {
  backend "local" {}
}

############# Data Sources #############
########################################

# Added following the github issue - https://github.com/terraform-aws-modules/terraform-aws-eks/issues/2009
data "aws_eks_cluster" "default" {
  name = module.eks.cluster_id
}

data "aws_eks_cluster_auth" "default" {
  name = module.eks.cluster_id
}

provider "kubernetes" {
  host                   = data.aws_eks_cluster.default.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.default.certificate_authority[0].data)
  token                  = data.aws_eks_cluster_auth.default.token
}


############# EKS #############
########################################
module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 18.0"

  cluster_name    = "masterclass-cluster"
  cluster_version = "1.23"

  cluster_endpoint_private_access = true
  cluster_endpoint_public_access  = true

  cluster_addons = {
    coredns = {
      resolve_conflicts = "OVERWRITE"
    }
    kube-proxy = {}
    vpc-cni = {
      resolve_conflicts = "OVERWRITE"
    }
  }

  cluster_encryption_config = [{
    provider_key_arn = "arn:aws:kms:eu-west-2:832611670348:key/1e5a5535-777f-4f25-989c-81d04c57c4c3"
    resources        = ["secrets"]
  }]

  #TODO Use data source or interpolate from another module
  vpc_id     = "vpc-0dd40889ba71c24b6"
  subnet_ids = ["subnet-0e69cb88d1ebd8ec6", "subnet-00ed099af8ab68db1"]

  # Self Managed Node Group(s)
  self_managed_node_group_defaults = {
    instance_type                          = "m6i.large"
    update_launch_template_default_version = true
    iam_role_additional_policies = [
      "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
    ]
  }

  self_managed_node_groups = {
    one = {
      name         = "mixed-1"
      max_size     = 5
      desired_size = 2

      use_mixed_instances_policy = true
      mixed_instances_policy = {
        instances_distribution = {
          on_demand_base_capacity                  = 0
          on_demand_percentage_above_base_capacity = 10
          spot_allocation_strategy                 = "capacity-optimized"
        }

        override = [
          {
            instance_type     = "m5.large"
            weighted_capacity = "1"
          },
          {
            instance_type     = "m6i.large"
            weighted_capacity = "2"
          },
        ]
      }
    }
  }

  # EKS Managed Node Group(s)
  eks_managed_node_group_defaults = {
    disk_size      = 50
    instance_types = ["t3.large", "m5.large"]
  }

  eks_managed_node_groups = {
    blue = {}
    green = {
      min_size     = 1
      max_size     = 10
      desired_size = 1

      instance_types = ["t3.large"]
      capacity_type  = "SPOT"
    }
  }

  # Fargate Profile(s)
  fargate_profiles = {
    default = {
      name = "default"
      selectors = [
        {
          namespace = "default"
        }
      ]
    }


  }

  # aws-auth configmap
  # This might throw and error - Read the Github issue here - https://github.com/terraform-aws-modules/terraform-aws-eks/issues/2009
  manage_aws_auth_configmap = true


  aws_auth_roles = [
    {
      rolearn  = "arn:aws:iam::832611670348:role/AllowLambdaAndS3"
      username = "LambdaToS3"
      groups   = ["system:masters"]
    },
  ]

  aws_auth_users = [
    {
      userarn  = "arn:aws:iam::832611670348:user/masterclass"
      username = "dare"
      groups   = ["system:masters"]
    },
    {
      userarn  = "arn:aws:iam::832611670348:user/masterclass"
      username = "abraham"
      groups   = ["system:masters"]
    },
  ]

  #   aws_auth_accounts = [
  #     "777777777777",
  #     "888888888888",
  #   ]

  tags = {
    Environment = "dev"
    Terraform   = "true"
  }
}
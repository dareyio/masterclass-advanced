############# Provider & Backend #############
########################################

# Not stable yet

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
  name = module.eks.cluster_name
}

data "aws_eks_cluster_auth" "default" {
  name = module.eks.cluster_name
}

provider "kubernetes" {
  host                   = data.aws_eks_cluster.default.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.default.certificate_authority[0].data)
  token                  = data.aws_eks_cluster_auth.default.token
}



module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 19.0"

  cluster_name    = "liveclasses"
  cluster_version = "1.24"

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

  vpc_id                   = "vpc-0814ba131b473e42d"
  subnet_ids               = ["subnet-0a5f6202a104f5e0f", "subnet-0a6132de49ae78d8c"]
  control_plane_subnet_ids = ["subnet-0a5f6202a104f5e0f", "subnet-0a6132de49ae78d8c"]

  # Self Managed Node Group(s)
  self_managed_node_group_defaults = {
    instance_type                          = "m6i.large"
    update_launch_template_default_version = true
    iam_role_additional_policies = {
      AmazonSSMManagedInstanceCore = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
    }
  }

  self_managed_node_groups = {
    one = {
      name         = "mixed-1"
      max_size     = 5
      desired_size = 2

      use_mixed_instances_policy = true
      mixed_instances_policy = {
        instances_distribution = {
          on_demand_base_capacity                  = 5
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
    # instance_types = ["m6i.large", "m5.large", "m5n.large", "m5zn.large"]
    #  Error: creating EKS Node Group (liveclasses:blue-20230422163021182600000001): 
    #  InvalidParameterException: The following supplied instance types do not exist: [m5n.large, m5zn.large]
    instance_types = ["m6i.large", "m5.large"]
  }

  eks_managed_node_groups = {}

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
  manage_aws_auth_configmap = true

  aws_auth_roles = []

  aws_auth_users = [
    {
      userarn  = "arn:aws:iam::571131858325:user/dare"
      username = "dare"
      groups   = ["system:masters"]
    },
  ]

  aws_auth_accounts = []

  tags = {
    Environment = "dev"
    Terraform   = "true"
  }
}
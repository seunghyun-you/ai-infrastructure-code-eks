# must be setting "aws configure" or "Environment Variables"
data "aws_caller_identity" "aws_account_info" {}

# IP Information of my labtop computer public address
data "http" "myip" {
  url = "http://ifconfig.me"
}

# Use data and filtering to get ami information for amazon_linux_2023 lastest version.  
data "aws_ami" "amazon_linux_2023" {
  most_recent = true
  owners      = ["amazon"]
  filter {
    name   = "name"
    values = ["al2023-ami-2023*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }
}

# eks
data "aws_eks_cluster_auth" "default" {
  name = module.eks_ap.eks_cluster_info.eks_cluster_name
}

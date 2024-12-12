# create common pem key file 
module "ec2_key_pair" {
  source = "terraform-aws-modules/key-pair/aws"

  key_name           = var.key_pair_config.key_name
  create_private_key = var.key_pair_config.create_private_key
}
resource "local_file" "test_local" {
  filename        = var.key_pair_config.filename
  file_permission = var.key_pair_config.file_permission
  content         = module.ec2_key_pair.private_key_pem
}

module "ec2_bastion" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "5.0.0"

  ami                    = var.ec2_config["bastion"].ami
  key_name               = var.ec2_config["bastion"].key_name
  subnet_id              = var.ec2_config["bastion"].subnet_id
  instance_type          = var.ec2_config["bastion"].instance_type
  vpc_security_group_ids = var.ec2_config["bastion"].vpc_security_group_ids

  iam_instance_profile = var.ec2_config["bastion"].iam_instance_profile

  tags = var.ec2_config["bastion"].ec2_name

  depends_on = [module.ec2_key_pair]
}

module "ec2_eks_workspace" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "5.0.0"

  ami                    = var.ec2_config["eks_workspace"].ami
  key_name               = var.ec2_config["eks_workspace"].key_name
  subnet_id              = var.ec2_config["eks_workspace"].subnet_id
  instance_type          = var.ec2_config["eks_workspace"].instance_type
  vpc_security_group_ids = var.ec2_config["eks_workspace"].vpc_security_group_ids

  iam_instance_profile = var.ec2_config["eks_workspace"].iam_instance_profile

  tags = var.ec2_config["eks_workspace"].ec2_name

  depends_on = [module.ec2_key_pair]
}

provider "aws" {
  region = "${var.aws_region}"
}

# Data source for network
data "terraform_remote_state" "dev_network" {
  backend = "atlas"
  config {
    name = "${var.tfe_network_org}/${var.tfe_network_workspace}"
  }
}

# Data source for redis
data "terraform_remote_state" "redis" {
  backend = "atlas"
  config {
    name = "${var.tfe_network_org}/${var.tfe_redis_workspace}"
  }
}

# simple ec2 server
module "stemcell-server" {
  source     = "app.terraform.io/kawsar-org/compute/aws"
  aws_region     = "${var.aws_region}"
  name       = "stemcell-server"
  ami_id     = "${data.aws_ami.ubuntu.id}"
  owner      = "${var.owner}"
  ttl        = "${var.ttl}"
  count      = "1"
  key_name   = "${var.key_name}"
  subnet_id  = "${data.terraform_remote_state.dev_network.public_subnet1_id}"
  sg_ids     = ["${data.terraform_remote_state.dev_network.security_group_id}"]
}

module "terraform-aws-appload-python2redis" {
  source  = "app.terraform.io/kawsar-org/appload-python2redis/aws"
  private_key_data = "${var.private_key_data}"
  redis_host = "${data.terraform_remote_state.redis.public_dns[0]}"
  redis_password = "${data.terraform_remote_state.redis.redis_password}"
  target_host = "${module.stemcell-server.public_dns[0]}"
}

output "public_dns" {
  value = "${module.stemcell-server.public_dns}"
}

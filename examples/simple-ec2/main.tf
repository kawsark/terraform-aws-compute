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

# simple ec2 server
module "stemcell-server" {
  source     = "app.terraform.io/kawsar-org/compute/aws"
  region     = "${var.aws_region}"
  name       = "stemcell-server"
  ami_id     = "${data.aws_ami.ubuntu.id}"
  owner      = "${var.owner}"
  ttl        = "${var.ttl}"
  count      = "1"
  key_name   = "${var.key_name}"
  subnet_id  = "${data.terraform_remote_state.dev_network.public_subnet1_id}"
  sg_ids     = ["${data.terraform_remote_state.dev_network.security_group_id}"]
}

output "public_dns" {
  value = "${module.stemcell-server.public_dns}"
}

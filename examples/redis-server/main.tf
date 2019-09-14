provider "aws" {
  region = var.aws_region
}

# Data source for network
data "terraform_remote_state" "dev_network" {
  backend = "atlas"
  config {
    name = var.tfe_network_org/var.tfe_network_workspace
  }
}

# Redis password
resource "random_string" "password" {
  length = 8
  special = false
}

# Render userdata
data "template_file" "startup_script" {
  template = "${file("${path.module}/redis.sh.tpl")}"
  vars {
    redis_password = "${random_string.password.result}"
  }
}

# simple ec2 server
module "stemcell-server" {
  source     = "app.terraform.io/kawsar-org/compute/aws"
  #source = "../../"
  aws_region     = var.aws_region
  name       = "stemcell-server"
  ami_id     = "${data.aws_ami.ubuntu.id}"
  owner      = var.owner
  ttl        = var.ttl
  instance_count      = "1"
  key_name   = var.key_name
  subnet_id  = "${data.terraform_remote_state.dev_network.public_subnet1_id}"
  sg_ids     = ["${data.terraform_remote_state.dev_network.security_group_id}"]
  user_data  = "${data.template_file.startup_script.rendered}"
}

output "public_dns" {
  value = "${module.stemcell-server.public_dns}"
}

output "redis_password" {
  value = "${random_string.password.result}"
  sensitive = true
}

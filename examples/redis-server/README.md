# terraform-aws-compute

This example repo provisions an `aws_instance` using a Terraform Enterprise private module registry. The instance runs a Redis instance.
The subnet id and security group id parameters are read via `terraform_remote_state` Datasources.
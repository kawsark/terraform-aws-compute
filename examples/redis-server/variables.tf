variable "tfe_network_org" {
  description = "Name of TFE Organization that contains Network workspace"
  default = "kawsar-org"
}

variable "tfe_network_workspace" {
  description = "Name of TFE workspace that contains network infrastructure"
  default = "aws-network-dev"
}

variable "aws_region" {
  description = "AWS region for Primary Vault server"
  default     = "us-east-1"
}

variable "owner" {
  description = "A value for the owner tag"
  default     = "demouser"
}

variable "ttl" {
  description = "A value for the ttl tag"
  default     = "48"
}

variable "key_name" {}

variable "environment" {
  default = "dev"
}

variable "instance_count" {
  default = 1  
}

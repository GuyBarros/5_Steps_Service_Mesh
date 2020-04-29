# Module Configuration Variables
data "http" "myipaddr" {
    url = "http://ipv4.icanhazip.com"
}

locals {
   host_access_ip = ["${chomp(data.http.myipaddr.body)}/32"]
   // host_access_ip = ["<AN IP>/32"]
}


variable "primary_region" {
  description = "The region to create your resources in."
  default     = "eu-west-2"
}

variable "secondary_region" {
  description = "The region to create your resources in."
  default     = "eu-west-1"
}

variable "owner" {
  description = "The user who is managing the lifecycle of this cluster"
}

variable "created-by" {
  description = "Tag used to identify resources created programmatically by Terraform"
  default     = "Terraform"
}

variable "public_key" {
  description = "The contents of the SSH public key to use for connecting to the cluster."
}

variable "clusterid" {
  description = "This is the deployment stage of the cluster. It should be unique for every cluster"
  default     = "dev-consul"
}


variable "server_number" {
  description = "The number of servers for consul leaders."
  default     = "3"
}

variable "server_instance_type" {
  description = "The type(size) of data servers (consul, consul, etc)."
  default     = "t2.medium"
}

variable "worker_number" {
  description = "The number of servers for consul workers."
  default     = "3"
}

variable "worker_instance_type" {
  description = "The type(size) for consul workers."
  default     = "t2.medium"
}

variable "primary_datacenter" {
  description = "The name you want to give the primary consul datacenter"
  default     = "dc1"
}

variable "secondary_datacenter" {
  description = "The name you want to give the seconday consul datacenter"
  default     = "dc2"
}

# General Variables
variable "consul_url" {
  description = "The url to download consul."
  default     = "https://releases.hashicorp.com/consul/0.10.0/consul_0.10.0_linux_amd64.zip"
}

variable "vpc_cidr_block" {
  description = "The top-level CIDR block for the VPC."
  default     = "10.1.0.0/16"
}

variable "cidr_blocks" {
  description = "The CIDR blocks to create the servers in."
  default     = ["10.1.1.0/24", "10.1.2.0/24"]
}

variable "consul_join" {
  description = "consul Auto-Join Tag Value"
  default     = "consul_join"
}
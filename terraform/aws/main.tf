terraform {
  required_version = ">= 0.12.0"
}

provider "aws" {
region               = var.primary_region
}

module "primary_cluster" {
  source               = "./modules/aws"
  cidr_blocks          = var.cidr_blocks
  clusterid            = var.clusterid
  created-by           = var.created-by
  region               = var.primary_region
  datacenter           = "${var.primary_datacenter}-${var.primary_region}"
  primary_datacenter   = "${var.primary_datacenter}-${var.primary_region}"
  host_access_ip       = var.host_access_ip
  consul_join           = var.consul_join
  consul_url            = var.consul_url
  owner                = var.owner
  public_key           = var.public_key
  server_instance_type = var.server_instance_type
  server_number        = var.server_number
  vpc_cidr_block       = var.vpc_cidr_block
  worker_instance_type = var.worker_instance_type
  worker_number        = var.worker_number
}

module "seconday_cluster" {
  source               = "./modules/aws"
  cidr_blocks          = var.cidr_blocks
  clusterid            = var.clusterid
  created-by           = var.created-by
  datacenter           = "${var.secondary_datacenter}-${var.secondary_region}"
  primary_datacenter   = "${var.primary_datacenter}-${var.primary_region}"
  host_access_ip       = var.host_access_ip
  consul_join           = var.consul_join
  consul_url            = var.consul_url
  owner                = var.owner
  public_key           = var.public_key
  region               = var.secondary_region
  server_instance_type = var.server_instance_type
  server_number        = var.server_number
  vpc_cidr_block       = var.vpc_cidr_block
  worker_instance_type = var.worker_instance_type
  worker_number        = var.worker_number
}
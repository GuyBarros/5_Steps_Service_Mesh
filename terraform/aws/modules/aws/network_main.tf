resource "aws_vpc" "consul_vpc" {
  cidr_block           = var.vpc_cidr_block
  enable_dns_hostnames = true

  tags = {
    Name           = "${var.clusterid}-vpc-${random_id.consul_cluster.hex}"
    owner          = var.owner
    created-by     = var.created-by
    consul_join     = var.consul_join
  }
}

resource "aws_internet_gateway" "consul_igw" {
  vpc_id = aws_vpc.consul_vpc.id

  tags = {
    Name           = "${var.clusterid}-igw-${random_id.consul_cluster.hex}"
    owner          = var.owner
    created-by     = var.created-by
    consul_join     = var.consul_join
  }
}

resource "aws_route" "consul_internet_access" {
  route_table_id         = aws_vpc.consul_vpc.main_route_table_id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.consul_igw.id
}

resource "aws_subnet" "consul_subnet" {
  count                   = "${length(var.cidr_blocks)}"
  vpc_id                  = aws_vpc.consul_vpc.id
  availability_zone       = "${data.aws_availability_zones.available.names[count.index]}"
  cidr_block              = "${var.cidr_blocks[count.index]}"
  map_public_ip_on_launch = true

  tags = {
    Name           = "${var.clusterid}-subnet-${random_id.consul_cluster.hex}"
    owner          = var.owner
    created-by     = var.created-by
    consul_join     = var.consul_join
  }
}
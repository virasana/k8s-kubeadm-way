resource "aws_vpc" "vpc_k8s" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true
  tags                 = merge(local.common_tags,
  {
    description = "vpc-k8s"
  })
}

resource "aws_subnet" "public_k8s" {
  cidr_block        = "10.0.0.0/24"
  vpc_id            = aws_vpc.vpc_k8s.id
  availability_zone = var.availability_zone
  tags              = merge(local.common_tags,
  {
    description = "public-subnet-k8s"
  })
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc_k8s.id
  tags   = merge(local.common_tags,
  {
    description = "k8s-internet-gateway"
  })
}

resource "aws_route_table" "rt" {
  vpc_id = aws_vpc.vpc_k8s.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  tags   = merge(local.common_tags,
  {
    description = "k8s-route-table"
  })
}

resource "aws_route_table_association" "subnet-association" {
  subnet_id      = aws_subnet.public_k8s.id
  route_table_id = aws_route_table.rt.id
}
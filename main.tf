# ==========================================
# 1. Virginia (Simulated On-Prem) - 10.0.0.0/16
# ==========================================

resource "aws_vpc" "vpc_onprem" {
  provider   = aws.virginia
  cidr_block = "10.0.0.0/16"
  tags       = { Name = "On-Prem-VPC" }
}

resource "aws_subnet" "subnet_onprem" {
  provider                = aws.virginia
  vpc_id                  = aws_vpc.vpc_onprem.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true
  availability_zone       = "us-east-1a"
  tags                    = { Name = "On-Prem-Subnet" }
}

resource "aws_internet_gateway" "igw_onprem" {
  provider = aws.virginia
  vpc_id   = aws_vpc.vpc_onprem.id
}

resource "aws_route_table" "rt_onprem" {
  provider = aws.virginia
  vpc_id   = aws_vpc.vpc_onprem.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw_onprem.id
  }
  tags = { Name = "On-Prem-RT" }
}

resource "aws_route_table_association" "assoc_onprem" {
  provider       = aws.virginia
  subnet_id      = aws_subnet.subnet_onprem.id
  route_table_id = aws_route_table.rt_onprem.id
}

# ==========================================
# 2. Oregon (Cloud Target) - 192.168.0.0/16
# ==========================================

resource "aws_vpc" "vpc_cloud" {
  provider   = aws.oregon
  cidr_block = "192.168.0.0/16"
  tags       = { Name = "Cloud-VPC" }
}

resource "aws_subnet" "subnet_cloud" {
  provider                = aws.oregon
  vpc_id                  = aws_vpc.vpc_cloud.id
  cidr_block              = "192.168.1.0/24"
  map_public_ip_on_launch = true
  availability_zone       = "us-west-2a"
  tags                    = { Name = "Cloud-Subnet" }
}

resource "aws_internet_gateway" "igw_cloud" {
  provider = aws.oregon
  vpc_id   = aws_vpc.vpc_cloud.id
}

resource "aws_route_table" "rt_cloud" {
  provider = aws.oregon
  vpc_id   = aws_vpc.vpc_cloud.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw_cloud.id
  }
  tags = { Name = "Cloud-RT" }
}

resource "aws_route_table_association" "assoc_cloud" {
  provider       = aws.oregon
  subnet_id      = aws_subnet.subnet_cloud.id
  route_table_id = aws_route_table.rt_cloud.id
}
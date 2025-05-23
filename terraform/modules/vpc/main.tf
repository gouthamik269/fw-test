
#VPC
resource "aws_vpc" "fw_vpc" {
  cidr_block           = local.vpc_cidr
  enable_dns_hostnames = true
  tags = {
    Name = local.vpc_name
  }
  enable_dns_support = true
}

#Private subnets, RT, RTA

resource "aws_subnet" "private-subnet-1a" {
  
  availability_zone       = "${var.region}a"
  cidr_block              = local.private_subnet_1a_cidr
  vpc_id                  = aws_vpc.fw_vpc.id
  map_public_ip_on_launch = false
  tags = {
    Name                  = local.private-subnet-1a_name,
  }
}

resource "aws_route_table" "private_route_table_1a" {
  
  vpc_id = aws_vpc.fw_vpc.id
  tags = {
    Name = local.private_route_table_name_1a
  }
}
resource "aws_route_table_association" "private_route_table_association_1a" {
  
  route_table_id = aws_route_table.private_route_table_1a.id
  subnet_id      = aws_subnet.private-subnet-1a.id
}

resource "aws_subnet" "private-subnet-1b" {
  availability_zone       = "${var.region}b"
  cidr_block              = local.private_subnet_1b_cidr
  vpc_id                  = aws_vpc.fw_vpc.id
  map_public_ip_on_launch = false
  tags = {
    Name                  = local.private-subnet-1b_name
  }
}

resource "aws_route_table" "private_route_table_1b" {
  vpc_id = aws_vpc.fw_vpc.id
  tags = {
    Name = local.private_route_table_name_1b
  }
}

resource "aws_route_table_association" "private_route_table_association_1b" { 
  route_table_id = aws_route_table.private_route_table_1b.id
  subnet_id      = aws_subnet.private-subnet-1b.id
}

resource "aws_subnet" "private-subnet-1c" {
  availability_zone       = "${var.region}c"
  cidr_block              = local.private_subnet_1c_cidr
  vpc_id                  = aws_vpc.fw_vpc.id
  map_public_ip_on_launch = false
  tags = {
    Name                  = local.private-subnet-1c_name
  }
}
resource "aws_route_table" "private_route_table_1c" {
  vpc_id = aws_vpc.fw_vpc.id
  tags = {
    Name = local.private_route_table_name_1c
  }
}

resource "aws_route_table_association" "private_route_table_association_1c" {
  route_table_id = aws_route_table.private_route_table_1c.id
  subnet_id      = aws_subnet.private-subnet-1c.id
}

#public Subnets,RT,RTA

resource "aws_subnet" "public-subnet-1a" {
  
  availability_zone       = "${var.region}a"
  cidr_block              = local.public_subnet_1a_cidr
  vpc_id                  = aws_vpc.fw_vpc.id
  map_public_ip_on_launch = false
  tags = {
    Name                     = local.public-subnet-1a_name
  }
}

resource "aws_route_table" "public_route_table_1a" {
  
  vpc_id = aws_vpc.fw_vpc.id
  tags = {
    Name = local.public_route_table_name_1a
  }
}

resource "aws_route_table_association" "public_route_table_association_1a" {
  route_table_id = aws_route_table.public_route_table_1a.id
  subnet_id      = aws_subnet.public-subnet-1a.id
}

resource "aws_subnet" "public-subnet-1b" {
  availability_zone       = "${var.region}b"
  cidr_block              = local.public_subnet_1b_cidr
  vpc_id                  = aws_vpc.fw_vpc.id
  map_public_ip_on_launch = false
  tags = {
    Name                     = local.public-subnet-1b_name
  }
}

resource "aws_route_table" "public_route_table_1b" {
  vpc_id = aws_vpc.fw_vpc.id
  tags = {
    Name = local.public_route_table_name_1b
  }
}

resource "aws_route_table_association" "public_route_table_association_1b" {
  
  route_table_id = aws_route_table.public_route_table_1b.id
  subnet_id      = aws_subnet.public-subnet-1b.id
}

resource "aws_subnet" "public_subnet_1c" {
  availability_zone       = "${var.region}c"
  cidr_block              = local.public_subnet_1c_cidr
  vpc_id                  = aws_vpc.fw_vpc.id
  map_public_ip_on_launch = false
  tags = {
    Name                     = local.public-subnet-1c_name
  }
}

resource "aws_route_table" "public_route_table_1c" { 
  vpc_id = aws_vpc.fw_vpc.id
  tags = {
    Name = local.public_route_table_name_1c
  }
}

resource "aws_route_table_association" "public_route_table_association_1c" { 
  route_table_id = aws_route_table.public_route_table_1c.id
  subnet_id      = aws_subnet.public_subnet_1c.id
}

#igw

resource "aws_internet_gateway" "internet-gw" {
  vpc_id = aws_vpc.fw_vpc.id
  tags = {
    Name = local.igw_name
  }
}

#pubic Routes

resource "aws_route" "public-routes-1a" {
  route_table_id         = aws_route_table.public_route_table_1a.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.internet-gw.id
}
resource "aws_route" "public-routes-1b" {
  route_table_id         = aws_route_table.public_route_table_1b.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.internet-gw.id
}
resource "aws_route" "public-routes-1c" {
  route_table_id         = aws_route_table.public_route_table_1c.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.internet-gw.id
}

#Elastic IP

resource "aws_eip" "nat_eip_1a" {
  count  = var.enable_nat_gateway ? 1 : 0
  domain = "vpc"
  tags = {
    Name = "nat-eip-1a"
  }
}

resource "aws_eip" "nat_eip_1b" {
  count  = var.enable_nat_gateway ? 1 : 0
  domain = "vpc"
  tags = {
    Name = "nat-eip-1b"
  }
}

resource "aws_eip" "nat_eip_1c" {
  count  = var.enable_nat_gateway ? 1 : 0
  domain = "vpc"
  tags = {
    Name = "nat-eip-1c"
  }
}

#NAT 

resource "aws_nat_gateway" "nat-gateway-1a" {
  count         = var.enable_nat_gateway ? 1 : 0
  allocation_id = aws_eip.nat_eip_1a[0].id
  subnet_id     = aws_subnet.public-subnet-1a.id
  tags = {
    Name = "${var.resource}-natgw-1a"
  }
}

resource "aws_nat_gateway" "nat-gateway-1b" {
  count         = var.enable_nat_gateway ? 1 : 0
  allocation_id = aws_eip.nat_eip_1b[0].id
  subnet_id     = aws_subnet.public-subnet-1b.id
  tags = {
    Name = "${var.resource}-natgw-1b"
  }
}

resource "aws_nat_gateway" "nat-gateway-1c" {
  count         = var.enable_nat_gateway ? 1 : 0
  allocation_id = aws_eip.nat_eip_1c[0].id
  subnet_id     = aws_subnet.public_subnet_1c.id
  tags = {
    Name = "${var.resource}-natgw-1c"
  }
}

resource "aws_route" "private_nat-1a" {
  count                  = var.enable_nat_gateway ? 1 : 0
  route_table_id         = aws_route_table.private_route_table_1a.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat-gateway-1a[count.index].id
}

resource "aws_route" "private_nat-1b" {
  count                  = var.enable_nat_gateway ? 1 : 0
  route_table_id         = aws_route_table.private_route_table_1b.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat-gateway-1b[count.index].id
}

resource "aws_route" "private_nat-1c" {
  count                  = var.enable_nat_gateway ? 1 : 0
  route_table_id         = aws_route_table.private_route_table_1c.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat-gateway-1c[count.index].id
}


locals {

  vpc_name                 = "${var.resource}-vpc"
  private_route_table_name_1a = "${var.resource}-private_route_table-1a"
  private_route_table_name_1b = "${var.resource}-private_route_table-1b"
  private_route_table_name_1c = "${var.resource}-private_route_table-1c"
  public_route_table_name_1a  = "${var.resource}-public_route_table-1a"
  public_route_table_name_1b  = "${var.resource}-public_route_table-1b"
  public_route_table_name_1c  = "${var.resource}-public_route_table-1c"
  private-subnet-1a_name   = "${var.resource}-private-subnet-1a"
  private-subnet-1b_name   = "${var.resource}-private-subnet-1b"
  private-subnet-1c_name   = "${var.resource}-private-subnet-1c"
  public-subnet-1a_name    = "${var.resource}-public-subnet-1a"
  public-subnet-1b_name    = "${var.resource}-public-subnet-1b"
  public-subnet-1c_name    = "${var.resource}-public-subnet-1c"
  igw_name                 = "${var.resource}-igw"
  vpc_cidr                 = "${var.vpc_subnet_prefix}.0.0/16"
  private_subnet_1a_cidr   = "${var.vpc_subnet_prefix}.32.0/19"
  private_subnet_1b_cidr   = "${var.vpc_subnet_prefix}.64.0/19"
  private_subnet_1c_cidr   = "${var.vpc_subnet_prefix}.96.0/19"
  public_subnet_1a_cidr    = "${var.vpc_subnet_prefix}.0.0/22"
  public_subnet_1b_cidr    = "${var.vpc_subnet_prefix}.4.0/22"
  public_subnet_1c_cidr    = "${var.vpc_subnet_prefix}.8.0/22"

}

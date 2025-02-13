# VPC
resource "aws_vpc" "main" {
  cidr_block       = var.vpc_cidr
  tags = {
    Name = var.vpc_name
  }
}

# Get all availability zones in the selected region
data "aws_availability_zones" "available" {}

# Public Subnet 1
resource "aws_subnet" "public_subnet" {
  count = length(var.public_cidr)
  vpc_id     = aws_vpc.main.id
  cidr_block = element(var.public_cidr,count.index)
    map_public_ip_on_launch = true
    #availability_zone = element(data.aws_availability_zones.available.names, count.index)
    availability_zone = element(data.aws_availability_zones.available.names, count.index)
  
  tags = {
    Name = "${var.tag}-public_subnet-${element(var.public_cidr,count.index)}"
  }
}

# Private Subnet 1
resource "aws_subnet" "private_subnet" {
  count = length(var.private_cidr)
  vpc_id     = aws_vpc.main.id
  cidr_block = element(var.private_cidr,count.index)
  availability_zone = data.aws_availability_zones.available.names[count.index]
  tags = {
    Name = "${var.tag}-Private Subnet${element(var.private_cidr,count.index)}"
  }
}

# eip 
resource "aws_eip" "nat1" {
  domain   = "vpc"
}

# Internet Gateway

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${var.tag}-igw"
  }
}

# nat
resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat1.id
  subnet_id     = aws_subnet.public_subnet[0].id

  tags = {
    Name = "${var.tag}-NAT"
  }
}

# Public Route Table
resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "${var.tag}- Public Route"
  }
}


# Private Route Table
resource "aws_route_table" "private_route_table" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.nat.id
  }

  tags = {
    Name = "${var.tag}- Private Route"}
}

# Route Table Association

resource "aws_route_table_association" "public_subnet_a" {
  count = length(var.public_cidr)
  subnet_id      = aws_subnet.public_subnet[count.index].id
  route_table_id = aws_route_table.public_route_table.id
}

resource "aws_route_table_association" "private_subnet_a" {
  count = length(var.private_cidr)
  subnet_id      = aws_subnet.private_subnet[count.index].id
  route_table_id = aws_route_table.private_route_table.id
}


# count
# length
# element 

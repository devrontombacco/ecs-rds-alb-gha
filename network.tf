resource "aws_vpc" "main-vpc" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = var.vpc_name
  }
}


resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main-vpc.id

  tags = {
    Name = "${var.vpc_name}-igw"
  }
}

# PUBLIC SUBNETS 

resource "aws_subnet" "public1" {
  vpc_id                  = aws_vpc.main-vpc.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true
  availability_zone       = var.primary_az

  tags = {
    Name = "${var.vpc_name}-public1"
  }
}

resource "aws_subnet" "public2" {
  vpc_id                  = aws_vpc.main-vpc.id
  cidr_block              = "10.0.2.0/24"
  map_public_ip_on_launch = true
  availability_zone       = var.secondary_az
  tags = {
    Name = "${var.vpc_name}-public2"
  }
}

# PRIVATE SUBNETS 

resource "aws_subnet" "private1" {
  vpc_id                  = aws_vpc.main-vpc.id
  cidr_block              = "10.0.3.0/24"
  map_public_ip_on_launch = true
  availability_zone       = var.primary_az

  tags = {
    Name = "${var.vpc_name}-private1"
  }
}

resource "aws_subnet" "private2" {
  vpc_id                  = aws_vpc.main-vpc.id
  cidr_block              = "10.0.4.0/24"
  map_public_ip_on_launch = true
  availability_zone       = var.secondary_az
  tags = {
    Name = "${var.vpc_name}-private2"
  }
}

resource "aws_subnet" "private3" {
  vpc_id                  = aws_vpc.main-vpc.id
  cidr_block              = "10.0.5.0/24"
  map_public_ip_on_launch = true
  availability_zone       = var.primary_az

  tags = {
    Name = "${var.vpc_name}-private3"
  }
}

resource "aws_subnet" "private4" {
  vpc_id                  = aws_vpc.main-vpc.id
  cidr_block              = "10.0.6.0/24"
  map_public_ip_on_launch = true
  availability_zone       = var.secondary_az
  tags = {
    Name = "${var.vpc_name}-private4"
  }
}

# ROUTE TABLE (PUBLIC)  

resource "aws_route_table" "rt-public" {
  vpc_id = aws_vpc.main-vpc.id

  route {
    cidr_block = "10.0.1.0/24"
    gateway_id = aws_internet_gateway.igw.id
  }

  route {
    cidr_block = "10.0.2.0/24"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "${var.vpc_name}-rt-public"
  }
}

# ROUTE TABLE (PRIVATE)

resource "aws_route_table" "rt-private-primaryaz" {
  vpc_id = aws_vpc.main-vpc.id

  route {
    cidr_block = "10.0.3.0/24"
    gateway_id = aws_internet_gateway.igw.id
  }

  route {
    cidr_block = "10.0.5.0/24"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "${var.vpc_name}-rt-private-primaryaz"
  }
}

resource "aws_route_table" "rt-private-secondaryaz" {
  vpc_id = aws_vpc.main-vpc.id

  route {
    cidr_block = "10.0.4.0/24"
    gateway_id = aws_internet_gateway.igw.id
  }

  route {
    cidr_block = "10.0.6.0/24"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "${var.vpc_name}-rt-private-secondaryaz"
  }
}

# ROUTE TABLE ASSOCIATIONS (PUBLIC) 

resource "aws_route_table_association" "rt-public-assoc1" {
  subnet_id      = aws_subnet.public1.id
  route_table_id = aws_route_table.rt-public.id
}

resource "aws_route_table_association" "rt-public-assoc2" {
  subnet_id      = aws_subnet.public2.id
  route_table_id = aws_route_table.rt-public.id
}

# ROUTE TABLE ASSOCIATIONS (PRIVATE - PRIMARY AZ) 

resource "aws_route_table_association" "rt-private-primaryaz-assoc1" {
  subnet_id      = aws_subnet.private1.id
  route_table_id = aws_route_table.rt-private-primaryaz.id
}

resource "aws_route_table_association" "rt-private-primaryaz-assoc3" {
  subnet_id      = aws_subnet.private3.id
  route_table_id = aws_route_table.rt-private-primaryaz.id
}

# ROUTE TABLE ASSOCIATIONS (PRIVATE - SECONDARY AZ)

resource "aws_route_table_association" "rt-private-secondaryaz-assoc2" {
  subnet_id      = aws_subnet.private2.id
  route_table_id = aws_route_table.rt-private-secondaryaz.id
}

resource "aws_route_table_association" "rt-private-secondaryaz-assoc4" {
  subnet_id      = aws_subnet.private4.id
  route_table_id = aws_route_table.rt-private-secondaryaz.id
}

# Elastic IPs for NAT Gateway

resource "aws_eip" "eip1" {
  domain = "vpc"
}

resource "aws_eip" "eip2" {
  domain = "vpc"
}

# NAT Gateways

resource "aws_nat_gateway" "nat1" {
  allocation_id = aws_eip.eip1.id
  subnet_id     = aws_subnet.public1.id
  depends_on    = [aws_internet_gateway.igw]

  tags = {
    Name = "${var.vpc_name}-nat1"
  }
}

resource "aws_nat_gateway" "nat2" {
  allocation_id = aws_eip.eip2.id
  subnet_id     = aws_subnet.public2.id
  depends_on    = [aws_internet_gateway.igw]

  tags = {
    Name = "${var.vpc_name}-nat2"
  }
}

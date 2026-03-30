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


resource "aws_subnet" "public1" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true
  availability_zone       = var.primary_az

  tags = {
    Name = "${var.vpc_name}-public1"
  }
}

resource "aws_subnet" "public2" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.2.0/24"
  map_public_ip_on_launch = true
  availability_zone       = var.secondary_az
  tags = {
    Name = "${var.vpc_name}-public2"
  }
}

resource "aws_subnet" "private1" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.3.0/24"
  map_public_ip_on_launch = true
  availability_zone       = var.primary_az

  tags = {
    Name = "${var.vpc_name}-private1"
  }
}

resource "aws_subnet" "private2" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.4.0/24"
  map_public_ip_on_launch = true
  availability_zone       = var.secondary_az
  tags = {
    Name = "${var.vpc_name}-private2"
  }
}

resource "aws_subnet" "private3" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.5.0/24"
  map_public_ip_on_launch = true
  availability_zone       = var.primary_az

  tags = {
    Name = "${var.vpc_name}-private3"
  }
}

resource "aws_subnet" "private4" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.6.0/24"
  map_public_ip_on_launch = true
  availability_zone       = var.secondary_az
  tags = {
    Name = "${var.vpc_name}-private4"
  }
}


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

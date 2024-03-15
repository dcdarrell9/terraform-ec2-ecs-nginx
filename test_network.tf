
resource "aws_vpc" "test_vpc" {
  cidr_block = "10.0.0.0/16"

  enable_dns_hostnames = true
  enable_dns_support   = true
}

resource "aws_subnet" "test_public_subnets" {
  count             = 3
  vpc_id            = aws_vpc.test_vpc.id
  cidr_block        = "10.0.${count.index + 1}.0/24"
  availability_zone = element(var.availability_zones, count.index)

  map_public_ip_on_launch = true

  tags = {
    Name = "public-subnet-${count.index + 1}"
  }
}

resource "aws_subnet" "test_private_subnets" {
  count             = 3
  vpc_id            = aws_vpc.test_vpc.id
  cidr_block        = "10.0.${count.index + 4}.0/24"
  availability_zone = element(var.availability_zones, count.index)

  map_public_ip_on_launch = false

  tags = {
    Name = "private-subnet-${count.index + 1}"
  }
}

resource "aws_internet_gateway" "test_gateway" {
  vpc_id = aws_vpc.test_vpc.id

  tags = {
    Name = "test-gateway"
  }
}

resource "aws_route_table" "test_route_table_public" {
  count = 3
  
  vpc_id = aws_vpc.test_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.test_gateway.id
  }

  tags = {
    Name = "public-subnet-rt-${count.index + 1}"
  }
}

resource "aws_route_table_association" "test_route_table_association_public" {
  count = 3

  subnet_id      = aws_subnet.test_public_subnets[count.index].id
  route_table_id = aws_route_table.test_route_table_public[count.index].id
}

resource "aws_route_table" "test_route_table_private" {
  count = 3
  
  vpc_id = aws_vpc.test_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.test_gateway.id
  }

  tags = {
    Name = "private-subnet-rt-${count.index + 1}"
  }
}

resource "aws_route_table_association" "test_route_table_association_private" {
  count = 3

  subnet_id      = aws_subnet.test_private_subnets[count.index].id
  route_table_id = aws_route_table.test_route_table_private[count.index].id
}

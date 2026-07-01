resource "aws_internet_gateway" "ev-vpc-igw" {
  vpc_id = aws_vpc.ev_vpc.id
  tags = {
    Name = "ev_igw"
  }
}

resource "aws_subnet" "public_b" {
  vpc_id            = aws_vpc.ev_vpc.id
  cidr_block        = var.public_subnets.b
  availability_zone = "us-east-1b"
  tags = {
        Name = "public_subnet_az_b"
    }
}

resource "aws_subnet" "public_a" {
  vpc_id            = aws_vpc.ev_vpc.id
  cidr_block        = var.public_subnets.a
  availability_zone = "us-east-1a"
  tags = {
        Name = "public_subnet_az_a"
    }
}

resource "aws_route_table" "rt_public_a" {
  vpc_id = aws_vpc.ev_vpc.id
  tags = {
        Name = "Routetable_public_a"
    }
}

resource "aws_route_table_association" "rt_assoc_public_a" {
  subnet_id      = aws_subnet.public_a.id
  route_table_id = aws_route_table.rt_public_a.id
}

resource "aws_route" "route_a" {
  route_table_id            = aws_route_table.rt_public_a.id
  destination_cidr_block    = "0.0.0.0/0"
  gateway_id = aws_internet_gateway.ev-vpc-igw.id
}

resource "aws_route_table" "rt_public_b" {
  vpc_id = aws_vpc.ev_vpc.id
  tags = {
        Name = "Routetable_public_b"
    }
}

resource "aws_route_table_association" "rt_assoc_public_b" {
  subnet_id      = aws_subnet.public_b.id
  route_table_id = aws_route_table.rt_public_b.id
}

resource "aws_route" "route_b" {
  route_table_id            = aws_route_table.rt_public_b.id
  destination_cidr_block    = "0.0.0.0/0"
  gateway_id = aws_internet_gateway.ev-vpc-igw.id
}

resource "aws_lb" "alb_a" {
    name = "public-alb-a"
    internal = false
    load_balancer_type = "application"
    subnets = [aws_subnet.public_b.id, aws_subnet.public_a.id]
    tags = {
      Name = "alb"
    }
}


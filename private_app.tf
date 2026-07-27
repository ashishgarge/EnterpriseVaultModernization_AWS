resource "aws_subnet" "private_subnet_a" {
  vpc_id                  = aws_vpc.ev_vpc.id
  map_public_ip_on_launch = false
  cidr_block              = var.private_app_subnets.a
  availability_zone       = var.avilablity_zones[0]
  tags = {
    Name = "Private_app_subnet_az_a"
  }
}

resource "aws_subnet" "private_subnet_b" {
  vpc_id                  = aws_vpc.ev_vpc.id
  map_public_ip_on_launch = false
  cidr_block              = var.private_app_subnets.b
  availability_zone       = var.avilablity_zones[1]
  tags = {
    Name = "Private_app_subnet_az_b"
  }
}

resource "aws_route_table" "rt_private_a" {
  vpc_id = aws_vpc.ev_vpc.id
  tags = {
    Name = "Routetable_private_app_a"
  }
}

resource "aws_route_table_association" "rt_associate_private_a" {
  subnet_id      = aws_subnet.private_subnet_a.id
  route_table_id = aws_route_table.rt_private_a.id
}

resource "aws_route_table" "rt_private_b" {
  vpc_id = aws_vpc.ev_vpc.id
  tags = {
    Name = "routetable_private_app_b"
  }
}

resource "aws_route_table_association" "rt_associate_private_b" {
  subnet_id      = aws_subnet.private_subnet_b.id
  route_table_id = aws_route_table.rt_private_b.id
}

/*resource "aws_instance" "pvt_instance_a" {
  ami = var.ami_id
  instance_type = var.instance_type
  subnet_id = aws_subnet.private_subnet_a.id
  associate_public_ip_address = false
  vpc_security_group_ids = [aws_security_group.webserver_sg.id]
  key_name = var.key_name
  user_data = file("${path.module}/userdata.sh")

  depends_on = [aws_nat_gateway.ev_nat]

  tags = { Name = "private-web-server_us-east-1a" }
}

resource "aws_instance" "pvt_instance_b" {
  ami = var.ami_id
  instance_type = var.instance_type
  subnet_id = aws_subnet.private_subnet_b.id
  associate_public_ip_address = false
  vpc_security_group_ids = [aws_security_group.webserver_sg.id]
  key_name = var.key_name
  user_data = file("${path.module}/userdata.sh")
  depends_on = [aws_nat_gateway.ev_nat]
  tags = { Name = "private-web-server_us-east-1b" }
}*/


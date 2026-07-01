resource "aws_subnet" private_subnet_a {
    vpc_id = aws_vpc.ev_vpc.id
    map_public_ip_on_launch = false
    cidr_block = var.private_app_subnets.a
    availability_zone    = "us-east-1a"
    tags = {
        Name = "Private_app_subnet_az_a"
    }
}

resource "aws_subnet" private_subnet_b {
    vpc_id = aws_vpc.ev_vpc.id
    map_public_ip_on_launch = false
    cidr_block = var.private_app_subnets.b
    availability_zone    = "us-east-1b"
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
    subnet_id = aws_subnet.private_subnet_a.id
    route_table_id = aws_route_table.rt_private_a.id
}

resource "aws_route_table" "rt_private_b" {
    vpc_id = aws_vpc.ev_vpc.id
    tags = {
        Name = "routetable_private_app_b"
    }
}

resource "aws_route_table_association" "rt_associate_private_b" {
    subnet_id = aws_subnet.private_subnet_b.id
    route_table_id = aws_route_table.rt_private_b.id
}
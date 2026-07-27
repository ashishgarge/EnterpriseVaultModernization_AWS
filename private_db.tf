resource "aws_subnet" private_subnet_db_a {
    vpc_id = aws_vpc.ev_vpc.id
    map_public_ip_on_launch = false
    cidr_block = var.private_db_subnets.a
    availability_zone    = var.availability_zones[0]
    tags = {
        Name = "private_subnet_db_az_a"
    }
}

resource "aws_subnet" private_subnet_db_b {
    vpc_id = aws_vpc.ev_vpc.id
    map_public_ip_on_launch = false
    cidr_block = var.private_db_subnets.b
    availability_zone    = var.availability_zones[1]
    tags = {
        Name = "private_subnet_db_az_b"
    }
}

resource "aws_route_table" "rt_private_db_a" {
    vpc_id = aws_vpc.ev_vpc.id
    tags = {
        Name = "Routetable_private_db_a"
    }
}

resource "aws_route_table_association" "rt_associate_private_db_a" {
    subnet_id = aws_subnet.private_subnet_db_a.id
    route_table_id = aws_route_table.rt_private_db_a.id
}

resource "aws_route_table" "rt_private_db_b" {
    vpc_id = aws_vpc.ev_vpc.id
    tags = {
        Name = "Routetable_private_db_b"
    }
}

resource "aws_route_table_association" "rt_associate_private_db_b" {
    subnet_id = aws_subnet.private_subnet_db_b.id
    route_table_id = aws_route_table.rt_private_db_b.id
}


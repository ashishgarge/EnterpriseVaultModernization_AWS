resource "aws_subnet" private_subnet_db_a {
    vpc_id = aws_vpc.ev_vpc.id
    map_public_ip_on_launch = false
    cidr_block = var.private_db_subnets.a
    availability_zone = var.availability_zones[0]
    tags = {
        Name = "private_subnet_db_az_a"
    }
}

resource "aws_subnet" private_subnet_db_b {
    vpc_id = aws_vpc.ev_vpc.id
    map_public_ip_on_launch = false
    cidr_block = var.private_db_subnets.b
    availability_zone = var.availability_zones[1]
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

/*resource "aws_db_subnet_group" "ev_db_subnet_group" {
    name = "ev-db-subnet-group"
    subnet_ids = [
        aws_subnet.private_subnet_db_a.id,
        aws_subnet.private_subnet_db_b.id
    ]
    tags = {
        Name = "ev-db-subnet-group"
    }
}*/

/*data "aws_secretsmanager_secret" "db_password_secret" {
    name = "db_password"
    secret_id = "db_password"
}

resource "aws_db_instance" "ev_db_instance" {
    allocated_storage = 5
    engine = "mssql"
    engine_version = "15.00"
    instance_class = "db.t3.micro"
    db_name = var.db_name
    username = var.db_username
    password = var.db_password
    parameter_group_name = "default.mssql15.00"
    skip_final_snapshot = true
    publicly_accessible = false
    vpc_security_group_ids = [aws_security_group.db_security_group.id]
    db_subnet_group_name = aws_db_subnet_group.ev_db_subnet_group.name
}*/




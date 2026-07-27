resource "aws_internet_gateway" "ev-vpc-igw" {
  vpc_id = aws_vpc.ev_vpc.id
  tags = {
    Name = "ev_igw"
  }
}

resource "aws_eip" "ev_eip" {
  domain     = "vpc"
  depends_on = [aws_internet_gateway.ev-vpc-igw]
}

resource "aws_nat_gateway" "ev_nat" {
  allocation_id = aws_eip.ev_eip.id
  subnet_id     = aws_subnet.public_a.id
  tags          = { Name = "main-nat-gateway" }
}

resource "aws_subnet" "public_b" {
  vpc_id            = aws_vpc.ev_vpc.id
  cidr_block        = var.public_subnets.b
  availability_zone = var.avilablity_zones[1]
  tags = {
    Name = "public_subnet_az_b"
  }
}

resource "aws_subnet" "public_a" {
  vpc_id            = aws_vpc.ev_vpc.id
  cidr_block        = var.public_subnets.a
  availability_zone = var.avilablity_zones[0]
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
  route_table_id         = aws_route_table.rt_public_a.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.ev-vpc-igw.id
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
  route_table_id         = aws_route_table.rt_public_b.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.ev-vpc-igw.id
}

resource "aws_lb" "alb_a" {
  name               = "public-alb-a"
  internal           = false
  load_balancer_type = "application"
  subnets            = [aws_subnet.public_b.id, aws_subnet.public_a.id]
  tags = {
    Name = "alb"
  }
}

resource "aws_lb_target_group" "alb_tg" {
  name     = "alb-web-target-group"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.ev_vpc.id

  health_check {
    path                = "/"
    port                = "80"
    protocol            = "HTTP"
    healthy_threshold   = 3
    unhealthy_threshold = 3
    timeout             = 5
    interval            = 30
    matcher             = "200"
  }
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.alb_a.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.alb_tg.arn
  }
}

/*resource "aws_lb_target_group_attachment" "web_attach_a" {
  target_group_arn = aws_lb_target_group.alb_tg.arn
  target_id        = aws_instance.pvt_instance_a.id
  port             = 80
}

resource "aws_lb_target_group_attachment" "web_attach_b" {
  target_group_arn = aws_lb_target_group.alb_tg.arn
  target_id        = aws_instance.pvt_instance_b.id
  port             = 80
}*/

# Bastian host
resource "aws_instance" "bastian_host" {
  ami                         = var.ami_id
  instance_type               = var.instance_type
  subnet_id                   = aws_subnet.public_a.id
  associate_public_ip_address = true
  vpc_security_group_ids      = [aws_security_group.bastion_sg.id]
  key_name                    = var.key_name
  user_data                   = file("${path.module}/userdata.sh")
  tags                        = { Name = "bastian_host_a" }
}


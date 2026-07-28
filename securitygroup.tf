resource "aws_security_group" "ev_alb_sg" {
  name        = "alb-security-group"
  description = "Allow HTTP inbound traffic from anywhere"
  vpc_id      = aws_vpc.ev_vpc.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "alb_securitygroup"
  }
}

resource "aws_security_group" "webserver_sg" {
  name        = "private-ec2-security-group"
  description = "Allow inbound traffic from ALB only"
  vpc_id      = aws_vpc.ev_vpc.id

  ingress {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.ev_alb_sg.id]
  }

  ingress {
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = [aws_security_group.bastion_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "private_webserver_securitygroup"
  }
}

resource "aws_security_group" "bastion_sg" {
  name        = "bastion-security-group"
  description = "Allow SSH traffic to bastion host"
  vpc_id      = aws_vpc.ev_vpc.id

  # Inbound rules: Strict access to your IP address only
  ingress {
    description = "SSH from my trusted IP"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Outbound rules: Allow the bastion host to reach instances inside the VPC
  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "bastion-sg"
  }
}

resource "aws_security_group" "db_security_group" {
  name        = "db-security-group"
  description = "Allow inbound traffic from webserver security group"
  vpc_id      = aws_vpc.ev_vpc.id

  ingress {
    from_port       = 1433
    to_port         = 1433
    protocol        = "tcp"
    security_groups = [aws_security_group.webserver_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "asg_sg" {
  name        = "asg-security-group"
  description = "Allow traffic for the Auto Scaling Group instances"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Allow HTTP traffic from anywhere
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Allow SSH traffic from anywhere
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1" # Allow all outgoing traffic for anny protocol
    cidr_blocks = ["0.0.0.0/0"]
  }
}


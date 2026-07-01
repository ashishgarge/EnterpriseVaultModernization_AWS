resource "aws_vpc" "ev_vpc" {
   cidr_block = var.vpc_cidr
   tags = {
      Name = "ev_vpc"
   }
}
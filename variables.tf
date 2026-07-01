variable "private_app_subnets" {
  type = map
  default = {
    a = "10.0.11.0/24"
    b = "10.0.12.0/24"
  }
}

variable "private_db_subnets" {
  description = "Default values for public subnets."
  type        = map
  default = {
    a = "10.0.21.0/24"
    b = "10.0.22.0/24"
  }
}

variable "public_subnets" {
  type = map
  default = {
    a = "10.0.1.0/24"
    b = "10.0.2.0/24"
  }
}

variable "vpc_cidr" {
  description = "The network addressing for the default VPC."
  type        = string
  default     = "10.0.0.0/16"
}

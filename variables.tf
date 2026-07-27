variable "private_app_subnets" {
  type = map(any)
  default = {
    a = "10.0.11.0/24"
    b = "10.0.12.0/24"
  }
}

variable "private_db_subnets" {
  description = "Default values for public subnets."
  type        = map(any)
  default = {
    a = "10.0.21.0/24"
    b = "10.0.22.0/24"
  }
}

variable "public_subnets" {
  type = map(any)
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

variable "availability_zones" {
  description = "The availablity zones for the default VPC."
  type        = list(string)
  default     = ["us-east-1a", "us-east-1b"]
}

variable "desired_capacity" {
  description = "Desired number of instances in the ASG."
  type        = number
  default     = 2
}

variable "max_size" {
  description = "Maximum number of instances in the ASG."
  type        = number
  default     = 4
}
variable "min_size" {
  description = "Minimum number of instances in the ASG."
  type        = number
  default     = 2
}

variable "instance_type" {
  description = "The instance type for the EC2 instances."
  type        = string
  default     = "t3.micro"
}

variable "key_name" {
  description = "The name of the key pair to use for SSH access."
  type        = string
  default     = "keypair"
}




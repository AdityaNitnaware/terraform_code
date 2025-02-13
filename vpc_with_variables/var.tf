variable "vpc_name" {
  description = "Name of the VPC"
  type        = string
  default     = "my-vpc"
}

variable "vpc_cidr" {
    type = string
    default  = "10.0.0.0/16"
}

variable "public_cidr" {
    type = list(string)
    default  = ["10.0.1.0/24","10.0.2.0/24"]
}

variable "private_cidr" {
  type = list(string)
  default = [ "10.0.3.0/24","10.0.4.0/24" ]
}

# variable "azs" {
#     type = list(string)

# }

variable "tag" {
    type = string
    default = "my"
}


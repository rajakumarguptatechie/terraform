variable "aws_access_key" {
  description = "AWS Access Key"
  type       = string
  default    = ""
}

variable "aws_secret_key" {
  description = "AWS Secret Key"
  type       = string
  default    = ""
}

variable "region" {
  description = "AWS default Region"
  type       = string
  default    = "us-east-2"
}

variable "cidr_address" {
  description = "CIDR of subnet"
  type       = string
  default    = "172.16.10.0/24"
}

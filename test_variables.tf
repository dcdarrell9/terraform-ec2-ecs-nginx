
variable "aws_region" {
  type    = string
  default = "eu-west-2"
}

variable "availability_zones" {
  type    = list(string)
  default = ["eu-west-2a", "eu-west-2b", "eu-west-2c"]
}

variable "environment" {
  type    = string
  default = "test"
}

variable "account_id" {
  type        = string
  default     = "abc"
  description = "This is possibly needed to avoid manual bucket name changes for IAM"
}

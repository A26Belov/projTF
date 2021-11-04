variable "region" {
  description = "region EU-NORTH-1"
  default     = "eu-north-1"
}

variable "instance_type" {
  description = "Instance Type"
  default     = "t3.micro"
}

variable "key_name" {
  description = "INPUT Key Name for SSH connect to Instance"
  default     = ""
}

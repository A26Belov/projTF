variable "region" {
  description = "region EU-CENTRAL-1"
  default     = "eu-central-1"
}


variable "instance_type" {
  description = "Instance Type"
  default     = "t2.micro"
}

variable "key_name" {
  description = "INPUT Key Name for SSH connect to Instance"
  default     = ""
}


variable "allow_ports" {
  description = "ports 80, 443"
  type        = list(any)
  default     = ["80", "443"]
}

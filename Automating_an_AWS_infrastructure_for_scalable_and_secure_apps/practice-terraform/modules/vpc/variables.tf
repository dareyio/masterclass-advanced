variable "cidr_block" {
  type = string
  # default = "100.0.1.0/24"
}

variable "env_name" {
  type = string
}

variable "enable_dns_support" {
  type = bool
  default = true
}
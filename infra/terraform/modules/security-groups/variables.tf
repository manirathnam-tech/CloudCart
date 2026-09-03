variable "vpc_id" {
  description = "The ID of the VPC"
  type        = string
}

variable "app_port" {
  description = "The port on which the application listens"
  type        = number
  default     = 8080
}

variable "env" {
  description = "The environment for the resources (e.g., dev, prod)"
  type        = string
}

variable "service_names" {
  description = "Microservice names, one ECR repo per service"
  type        = list(string)
  default     = ["auth", "catalog", "cart", "order", "payment", "notification"]
}

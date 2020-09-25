variable "user" {
  description = "Login information"
  type        = map
  default     = {
    username = "admin"
    password = "ins3965!"
    url      = "https://173.36.219.123"
  }
}

variable "tenant" {
    description = "The name of the tenant"
    type        = string
    default     = "terraform_tenant"
}
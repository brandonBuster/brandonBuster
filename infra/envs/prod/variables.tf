variable "environment" {
  type        = string
  default     = "prod"
  description = "Environment name."
}

variable "location" {
  type        = string
  default     = "eastus"
  description = "Azure region for resources."
}

variable "prefix" {
  type        = string
  default     = "bb"
  description = "Short prefix for resource names."
}

variable "acr_sku" {
  type        = string
  default     = "Basic"
  description = "ACR SKU: Basic, Standard, Premium."
}

variable "container_app_api_image" {
  type        = string
  description = "Full image reference for the API container (e.g. bbprodacr.azurecr.io/api:latest)."
  default     = "mcr.microsoft.com/azuredocs/containerapps-helloworld:latest"
}

variable "container_app_api_port" {
  type        = number
  default     = 80
  description = "Target port for the API container (80 placeholder; 8000 for FastAPI)."
}

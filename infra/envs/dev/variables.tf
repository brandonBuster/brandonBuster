variable "environment" {
  type        = string
  default     = "dev"
  description = "Environment name (dev, prod)."
}

variable "location" {
  type        = string
  default     = "eastus"
  description = "Azure region for resources."
}

variable "prefix" {
  type        = string
  default     = "bb"
  description = "Short prefix for resource names (e.g. bb for brandonbuster)."
}

variable "acr_sku" {
  type        = string
  default     = "Basic"
  description = "ACR SKU: Basic, Standard, Premium."
}

variable "container_app_api_image" {
  type        = string
  description = "Full image reference for the API container (e.g. bbdevacr.azurecr.io/api:latest). Set after first push to ACR."
  default     = "mcr.microsoft.com/azuredocs/containerapps-helloworld:latest" # placeholder; replace with your ACR image
}

variable "container_app_api_port" {
  type        = number
  default     = 80
  description = "Target port for the API container (80 for default placeholder image; 8000 for FastAPI)."
}

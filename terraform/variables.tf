##############################################
# 🌍 General configuration variables
##############################################

variable "resource_group_name" {
  description = "Azure resource group name"
  type        = string
  default     = "todoapp-tf-rg"
}

variable "location" {
  description = "Azure region for all resources"
  type        = string
  default     = "southeastasia"
}

##############################################
# 🐳 Container Registry
##############################################

variable "acr_name" {
  description = "Azure Container Registry name"
  type        = string
  default     = "todotfappacr"
}

##############################################
# 🧩 Networking (VNet + Subnet)
##############################################

variable "vnet_name" {
  description = "Virtual Network name"
  type        = string
  default     = "todoapp-vnet"
}

variable "subnet_name" {
  description = "Subnet name for Container Apps"
  type        = string
  default     = "todoapp-subnet"
}

variable "vnet_address_space" {
  description = "VNet address space"
  type        = list(string)
  default     = ["10.0.0.0/16"]
}

variable "subnet_prefix" {
  description = "Subnet address prefix for Container Apps"
  type        = list(string)
  default     = ["10.0.2.0/23"]
}

##############################################
# ☁️ MongoDB Atlas
##############################################

variable "mongo_uri" {
  description = "MongoDB Atlas connection string"
  type        = string
  sensitive   = true
}

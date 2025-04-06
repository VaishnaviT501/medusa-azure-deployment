variable "resource_group_name" {
  type        = string
  description = "Azure Resource Group Name"
}

variable "location" {
  type        = string
  description = "Azure location (e.g., East India)"
}

variable "acr_name" {
  type        = string
  description = "Azure Container Registry Name"
}

variable "postgres_admin_user" {
  type        = string
  description = "PostgreSQL admin username"
}

variable "postgres_admin_password" {
  type        = string
  description = "PostgreSQL admin password"
}

variable "db_name" {
  type        = string
  description = "PostgreSQL database name"
}

variable "jwt_secret" {
  type        = string
  description = "JWT secret"
}

variable "cookie_secret" {
  type        = string
  description = "Cookie secret"
}

variable "admin_cors" {
  type        = string
  description = "CORS for admin"
}

variable "store_cors" {
  type        = string
  description = "CORS for store"
}

variable "environment" {
  type        = string
  default     = "prod"
  description = "Deployment environment"
}

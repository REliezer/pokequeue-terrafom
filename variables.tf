variable "subscription_id" {
    type        = string
    description = "The Azure subscription ID"  
}

variable "location" {
    type        = string
    description = "The Azure region where resources will be deployed"
    default     = "Central US"
}

variable "project" {
    type        = string
    description = "The name of the project"
    default     = "pokequeue"
}

variable "environment" {
    type        = string
    description = "The environment for the deployment (e.g., dev, test, prod)"
    default     = "dev"  
}

variable "tags" {
    type        = map(string)
    description = "A map of tags to assign to resources"
    default     = {
        environment = "development"
        date        = "aug-2025"
        createdBy   = "Terraform"
    }
}

variable "name" {
    type        = string
    description = "Using for evite 'already exists'"
    default     = "refe" 
}

variable "admin_sql_user" {
    type = string
    description = "The user for the SQL admin account"
}

variable "admin_sql_password" {
    type = string
    description = "The password for the SQL admin account"
}

variable "user_sql" {
    type = string
    description = "The user for the SQL user account"
}

variable "user_sql_password" {
    type = string
    description = "The password for the SQL user account"
}

variable "secret_key" {
    type = string
    description = "value of the secret key for the application"
}

variable "sql_driver" {
    type = string
    description = "ODBC driver for SQL Server"
}
variable "resource_group_name" {
  description = "The name of the resource group where the resources will be created."
  type        = string
}

variable "resource_group_location" {
  description = "The location for the resource group."
  type        = string
}

variable "firewall_rule_name" {
  description = "The name of the firewall rule for the MSSQL server."
  type        = string
}

variable "mssql_server_name" {
  description = "The name of the MSSQL server."
  type        = string
}

variable "mssql_server_login" {
  description = "The administrator login for the MSSQL server."
  type        = string
}


variable "mssql_server_password" {
  description = "The administrator password for the MSSQL server."
  type        = string
}

variable "mssql_database_name" {
  description = "The name of the MSSQL database."
  type        = string
}

variable "service_plan_name" {
  description = "The name of the service plan for the web app."
  type        = string
}

variable "web_app_name" {
  description = "The name of the Linux web app."
  type        = string
}

variable "github_repo_name" {
  description = "The name of the GitHub repository for the web app source control."
  type        = string
}
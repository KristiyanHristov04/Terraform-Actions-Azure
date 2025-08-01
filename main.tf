terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "4.38.1"
    }
  }
}

provider "azurerm" {
  subscription_id = "db3c4452-c8ce-4bfd-b603-52f86c2380a8"
  features {

  }
}

resource "random_integer" "ri" {
  min = 10000
  max = 99999
}

resource "azurerm_resource_group" "taskboardrg" {
  name     = "${var.resource_group_name}-${random_integer.ri.result}"
  location = var.resource_group_location
}

resource "azurerm_mssql_firewall_rule" "mssqlfirewallrule" {
  name             = "${var.firewall_rule_name}-${random_integer.ri.result}"
  server_id        = azurerm_mssql_server.mssqlserver.id
  start_ip_address = "0.0.0.0"
  end_ip_address   = "0.0.0.0"
}

resource "azurerm_mssql_server" "mssqlserver" {
  name                         = "${var.mssql_server_name}-${random_integer.ri.result}"
  resource_group_name          = azurerm_resource_group.taskboardrg.name
  location                     = azurerm_resource_group.taskboardrg.location
  version                      = "12.0"
  administrator_login          = var.mssql_server_login
  administrator_login_password = var.mssql_server_password
}

resource "azurerm_mssql_database" "mssqldatabase" {
  name         = "${var.mssql_database_name}${random_integer.ri.result}"
  server_id    = azurerm_mssql_server.mssqlserver.id
  collation    = "SQL_Latin1_General_CP1_CI_AS"
  license_type = "LicenseIncluded"
  max_size_gb  = 2
  sku_name     = "S0"
  enclave_type = "VBS"

  lifecycle {
    prevent_destroy = true
  }
}

resource "azurerm_service_plan" "taskboardsp" {
  name                = "${var.service_plan_name}-${random_integer.ri.result}"
  resource_group_name = azurerm_resource_group.taskboardrg.name
  location            = azurerm_resource_group.taskboardrg.location
  os_type             = "Linux"
  sku_name            = "F1"
}

resource "azurerm_linux_web_app" "taskboardwebapp" {
  name                = "${var.web_app_name}-${random_integer.ri.result}"
  resource_group_name = azurerm_resource_group.taskboardrg.name
  location            = azurerm_service_plan.taskboardsp.location
  service_plan_id     = azurerm_service_plan.taskboardsp.id

  connection_string {
    name  = "DefaultConnection"
    type  = "SQLAzure"
    value = "Data Source=tcp:${azurerm_mssql_server.mssqlserver.name}.database.windows.net,1433;Initial Catalog=${azurerm_mssql_database.mssqldatabase.name};User ID=${azurerm_mssql_server.mssqlserver.administrator_login};Password=${azurerm_mssql_server.mssqlserver.administrator_login_password};Trusted_Connection=False; MultipleActiveResultSets=True;"
  }

  site_config {
    always_on = false
    application_stack {
      dotnet_version = "6.0"
    }
  }
}

resource "azurerm_app_service_source_control" "taskboardsc" {
  app_id                 = azurerm_linux_web_app.taskboardwebapp.id
  repo_url               = var.github_repo_name
  branch                 = "master"
  use_manual_integration = true
}


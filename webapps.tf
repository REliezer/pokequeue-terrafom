resource "azurerm_service_plan" "sp" {
    name = "sp-${ var.project }-${var.name}-${ var.environment }"
    location = var.location
    resource_group_name = azurerm_resource_group.rg.name
    sku_name = "B1"
    os_type = "Linux"

    tags = var.tags
}

resource "azurerm_linux_web_app" "webappui" {
    name = "ui-${ var.project }-${var.name}-${ var.environment }"
    location = var.location
    resource_group_name = azurerm_resource_group.rg.name
    service_plan_id = azurerm_service_plan.sp.id

    site_config {
        always_on = false
        application_stack {
            docker_registry_url = "https://index.docker.io"
            docker_image_name = "nginx:latest"
            docker_registry_username = azurerm_container_registry.acr.name
            docker_registry_password = azurerm_container_registry.acr.admin_password
        }
    }

    app_settings = {
        DOCKER_ENABLE_CI = "true"
        SECRET_KEY       = var.secret_key
        SQL_DATABASE     = azurerm_mssql_database.db.name
        SQL_DRIVER       = var.sql_driver
        SQL_PASSWORD     = var.admin_sql_password
        SQL_SERVER       = azurerm_mssql_server.sqlserver.fully_qualified_domain_name
        SQL_USERNAME     = azurerm_mssql_server.sqlserver.administrator_login
        WEBSITES_PORT = "80"
    }

    tags = var.tags

}

resource "azurerm_linux_web_app" "webappapi" {
    name = "api-${ var.project }-${var.name}-${ var.environment }"
    location = var.location
    resource_group_name = azurerm_resource_group.rg.name
    service_plan_id = azurerm_service_plan.sp.id

    site_config {
        always_on = false
        application_stack {
            docker_registry_url = "https://index.docker.io"
            docker_image_name = "nginx:latest"
            docker_registry_username = azurerm_container_registry.acr.name
            docker_registry_password = azurerm_container_registry.acr.admin_password
        }
    }

    app_settings = {
        DOCKER_ENABLE_CI = "true"
        SECRET_KEY       = var.secret_key
        SQL_DATABASE     = azurerm_mssql_database.db.name
        SQL_DRIVER       = var.sql_driver
        SQL_PASSWORD     = var.admin_sql_password
        SQL_SERVER       = azurerm_mssql_server.sqlserver.fully_qualified_domain_name
        SQL_USERNAME     = azurerm_mssql_server.sqlserver.administrator_login
        WEBSITES_PORT = "80"
    }

    tags = var.tags
}
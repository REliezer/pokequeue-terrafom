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
            docker_registry_url = "https://acrpokequeuerefedev.azurecr.io"
            docker_image_name = "pokeui:latest"
            docker_registry_username = azurerm_container_registry.acr.name
            docker_registry_password = azurerm_container_registry.acr.admin_password
        }
    }

    app_settings = {
        DOCKER_ENABLE_CI = "true"
        WEBSITES_PORT = "3000"
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
            docker_registry_url = "https://acrpokequeuerefedev.azurecr.io"
            docker_image_name = "pokeapi:latest"
            docker_registry_username = azurerm_container_registry.acr.name
            docker_registry_password = azurerm_container_registry.acr.admin_password
        }
    }

    app_settings = {
        DOCKER_ENABLE_CI = "true"
        SECRET_KEY       = var.secret_key
        SQL_DATABASE     = azurerm_mssql_database.db.name
        SQL_DRIVER       = var.sql_driver
        SQL_SERVER       = azurerm_mssql_server.sqlserver.fully_qualified_domain_name
        SQL_USERNAME     = var.user_sql
        SQL_PASSWORD     = var.user_sql_password
        WEBSITES_PORT = "8000"
        AZURE_SAK = azurerm_storage_account.saccount.primary_connection_string
        AZURE_STORAGE_CONTAINER = azurerm_storage_container.c1.name
        QUEUE_NAME = azurerm_storage_queue.q1.name
    }

    tags = var.tags
}
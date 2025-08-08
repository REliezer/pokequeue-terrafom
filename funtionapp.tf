resource "azurerm_linux_function_app" "serverless" {
  name                = "serverless-${ var.project }-${ var.environment }"
  resource_group_name = azurerm_resource_group.rg.name
  location            = var.location
  storage_account_name       = azurerm_storage_account.saccountfunc.name
  storage_account_access_key = azurerm_storage_account.saccountfunc.primary_access_key
  service_plan_id            = azurerm_service_plan.sp.id

  site_config {
    application_stack {
      python_version = "3.12"
    }
  }

  app_settings = {
        AZURE_STORAGE_CONNECTION_STRING = azurerm_storage_account.saccountfunc.primary_connection_string
        BLOB_CONTAINER_NAME = azurerm_storage_container.c1.name
        QueueAzureWebJobsStorage = azurerm_storage_account.saccount.primary_connection_string
        STORAGE_ACCOUNT_NAME = azurerm_storage_account.saccount.name
    }

  tags = var.tags
}
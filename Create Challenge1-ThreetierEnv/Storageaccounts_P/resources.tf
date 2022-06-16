terraform {
backend "azurerm" {
resource_group_name= "test-PROD-CI-RG-TFSTATE"
storage_account_name = "testprodcistgtfstate"
container_name = "storagetfstate"
key = "prod.terraform.tfstate"
}
}

data "azurerm_resource_group" "test_rg_main" {
  name = "test-prod-ci-rg001"
}


resource "azurerm_storage_account" "test_stg" {
    count                = length(var.stgname)
  name                 = var.stgname[count.index]
  location            = data.azurerm_resource_group.test_rg_main.location
  resource_group_name = data.azurerm_resource_group.test_rg_main.name
  account_tier             = "Standard"
  account_replication_type = "LRS"

 tags={
    "Name of the Project"=var.project
    "Resource Name"=var.stgname[0]
    "Environment"=var.environment
}
}

resource "azurerm_storage_share" "test_diagstg_share" {
  name                 = var.sharename[0]
  storage_account_name = azurerm_storage_account.test_stg[1].name
  quota                = 100
  }


resource "azurerm_storage_share_directory" "test_diagstg_share_directory" {
  name                 = var.dirname[0]
  share_name           = azurerm_storage_share.test_diagstg_share.name
  storage_account_name = azurerm_storage_account.test_stg[1].name
}


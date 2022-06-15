terraform {
backend "azurerm" {
resource_group_name= "TEST-PROD-CI-RG-TFSTATE"
storage_account_name = "testprodcistgtfstate"
container_name = "rgtfstate"
key = "prod.terraform.tfstate"
}
}

# Creation of resource group for deployment of Production environment.

resource "azurerm_resource_group" "test_rg_main" {
  name     = var.rgname
  location = var.location
tags={
    "Name of the Project"=var.project
    "Resource Name"=var.rgname
    "Environment"=var.environment
}
}


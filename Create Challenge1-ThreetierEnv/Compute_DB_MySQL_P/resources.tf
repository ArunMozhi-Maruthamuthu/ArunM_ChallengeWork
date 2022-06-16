terraform {
backend "azurerm" {
resource_group_name= "test-PROD-CI-RG-TFSTATE"
storage_account_name = "testprodcistgtfstate"
container_name = "databasetfstate"
key = "prod.terraform.tfstate"
}
}

data "azurerm_resource_group" "test_rg_main" {
  name = "test-prod-ci-rg001"
}

data "azurerm_virtual_network" "test_vnet"{
resource_group_name  = data.azurerm_resource_group.test_rg_main.name
name="test-prod-ci-vnet"
}

//data "azurerm_subnet" "test_subnet_db"{
  //name="test-prod-ci-db-sn"
  //virtual_network_name = data.azurerm_virtual_network.test_vnet.name
  //resource_group_name  = data.azurerm_resource_group.test_rg_main.name
//}

resource "azurerm_mysql_server" "test_mysql01" {
name                = var.mysqlname
resource_group_name = data.azurerm_resource_group.test_rg_main.name
location=data.azurerm_resource_group.test_rg_main.location

  administrator_login          = "xxxxxxx"
  administrator_login_password = "xxxxxxx"

  sku_name   = "GP_Gen5_2"
  storage_mb = 256000
  version    = "5.7"

  auto_grow_enabled                 = true
  backup_retention_days             = 7
  geo_redundant_backup_enabled      = true
  infrastructure_encryption_enabled = false
  public_network_access_enabled     = true
  ssl_enforcement_enabled           = true
  ssl_minimal_tls_version_enforced  = "TLS1_2"

tags={
    "Name of the Project"=var.project
    "Resource Name"=var.rgname
    "Environment"=var.environment
}
}

#Add mysql to the DB Subnet

//resource "azurerm_mysql_virtual_network_rule" "test_mysqlrule01" {
//name                = "mysql-vnet-rule01"
//resource_group_name = data.azurerm_resource_group.test_rg_main.name
//server_name         = azurerm_mysql_server.test_mysql01.name
//subnet_id           = data.azurerm_subnet.test_subnet_db.id
//}


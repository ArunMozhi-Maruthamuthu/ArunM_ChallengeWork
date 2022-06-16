terraform {
backend "azurerm" {
resource_group_name= "test-PROD-CI-RG-TFSTATE"
storage_account_name = "testprodcistgtfstate"
container_name = "networktfstate"
key = "prod.terraform.tfstate"
}
}

data "azurerm_resource_group" "test_rg_main" {
  name = "test-prod-ci-rg001"
}

#Creation of Virtual Network for test Production

resource "azurerm_virtual_network" "test_vnet" {
  name                = var.vnet_name
  location            = var.location
  resource_group_name = data.azurerm_resource_group.test_rg_main.name
  address_space       = var.address_space
 tags={
    "Name of the Project"=var.project
    "Resource Name"=var.vnet_name
    "Environment"=var.environment
}
 }

#Creation of Subnet for test production environment

resource "azurerm_subnet" "test_subnet" {
  count                = length(var.Subnet_names)
  name                 = var.Subnet_names[count.index]
  resource_group_name  = data.azurerm_resource_group.test_rg_main.name
  virtual_network_name = azurerm_virtual_network.test_vnet.name
  address_prefixes     = [var.subnet_address[count.index]]
 }

#Creation of Network Interface Cards
#bastin machine
resource "azurerm_network_interface" "bastin_nic" {
  name                = var.nicname[0]
  location            = data.azurerm_resource_group.test_rg_main.location
  resource_group_name = data.azurerm_resource_group.test_rg_main.name
  enable_accelerated_networking=false
   tags={
    "Name of the Project"=var.project
    "Resource Name"=var.nicname[0]
    "Environment"=var.environment
}
  ip_configuration {
    name                          = var.nicconf[0]
    subnet_id                     = azurerm_subnet.test_subnet[2].id
    private_ip_address_allocation = "Dynamic"
  }
}

#Appserver VM

resource "azurerm_network_interface" "appservervm_nic" {
  name                = var.nicname[1]
  location            = data.azurerm_resource_group.test_rg_main.location
  resource_group_name = data.azurerm_resource_group.test_rg_main.name
  enable_accelerated_networking=false
   tags={
    "Name of the Project"=var.project
    "Resource Name"=var.nicname[1]
    "Environment"=var.environment
}
  ip_configuration {
    name                          = var.nicconf[1]
    subnet_id                     = azurerm_subnet.test_subnet[2].id
    private_ip_address_allocation = "Dynamic"
  }
  
}


# NSG creation for all VM's

resource "azurerm_network_security_group" "test_nsg" {
  count                = length(var.nsgname)
  name                 = var.nsgname[count.index]
  location            = data.azurerm_resource_group.test_rg_main.location
  resource_group_name = data.azurerm_resource_group.test_rg_main.name
   tags={
    "Name of the Project"=var.project
    "Resource Name"=var.nsgname[count.index]
    "Environment"=var.environment
}
}

#NSG association to bastin machine
resource "azurerm_network_interface_security_group_association" "bastin_associate" {
    network_interface_id      = azurerm_network_interface.bastin_nic.id
  network_security_group_id = azurerm_network_security_group.test_nsg[0].id
}

#NSG association to appservervm machine
resource "azurerm_network_interface_security_group_association" "appservervm_associate" {
    network_interface_id      = azurerm_network_interface.appservervm_nic.id
  network_security_group_id = azurerm_network_security_group.test_nsg[2].id
}

resource "azurerm_public_ip" "appgw_pip01" {
  name                = var.pipname[1]
  location            = data.azurerm_resource_group.test_rg_main.location
  resource_group_name = data.azurerm_resource_group.test_rg_main.name
  allocation_method   = "Static"
  sku                 = "Standard"
  availability_zone = "No-Zone"
   tags={
    "Name of the Project"=var.project
    "Resource Name"=var.pipname[1]
    "Environment"=var.environment
}
}

resource "azurerm_public_ip" "bastin_pip01" {
  name                = var.pipname[0]
  location            = data.azurerm_resource_group.test_rg_main.location
  resource_group_name = data.azurerm_resource_group.test_rg_main.name
  allocation_method   = "Static"
   tags={
    "Name of the Project"=var.project
    "Resource Name"=var.pipname[0]
    "Environment"=var.environment
}
}
resource "azurerm_public_ip" "appservervm_pip01" {
  name                = var.pipname[2]
  location            = data.azurerm_resource_group.test_rg_main.location
  resource_group_name = data.azurerm_resource_group.test_rg_main.name
  allocation_method   = "Static"
   tags={
    "Name of the Project"=var.project
    "Resource Name"=var.pipname[2]
    "Environment"=var.environment
}
}
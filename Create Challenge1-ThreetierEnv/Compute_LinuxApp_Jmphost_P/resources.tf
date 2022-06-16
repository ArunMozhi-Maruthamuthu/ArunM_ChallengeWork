terraform {
backend "azurerm" {
resource_group_name= "test-PROD-CI-RG-TFSTATE"
storage_account_name = "testprodcistgtfstate"
container_name = "computetfstate"
key = "prod.terraform.tfstate"
}
}

data "azurerm_resource_group" "test_rg_main" {
  name = "test-prod-ci-rg001"
}

data "azurerm_subnet" "test_subnet" {
  name                 = var.subnet_name
  virtual_network_name = var.vnetname
  resource_group_name  = data.azurerm_resource_group.test_rg_main.name

}

data "azurerm_network_interface" "bastin_nic"{
   name                = "test-prod-ci-bastin-nic"
  resource_group_name = data.azurerm_resource_group.test_rg_main.name
}

data "azurerm_network_interface" "appservervm_nic"{
   name                = "test-prod-ci-appservervm-nic"
  resource_group_name = data.azurerm_resource_group.test_rg_main.name
}

resource "azurerm_availability_set" "test_av" {
   count               = length(var.avname)
  name                 = var.avname[count.index]
 resource_group_name = data.azurerm_resource_group.test_rg_main.name
location=data.azurerm_resource_group.test_rg_main.location
   tags={
    "Name of the Project"=var.project
    "Resource Name"=var.avname[count.index]
    "Environment"=var.environment
}
}



#Create bastin VM

resource "azurerm_virtual_machine" "bastin_vm" {
name                  = var.vm_name[0]
 resource_group_name = data.azurerm_resource_group.test_rg_main.name
location=data.azurerm_resource_group.test_rg_main.location
    network_interface_ids = [data.azurerm_network_interface.bastin_nic.id]
    vm_size                  = var.vm_size[0]
availability_set_id=azurerm_availability_set.test_av[0].id

  storage_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }

   storage_os_disk {
       name              = var.os_disk_name[0]
       caching           = "ReadWrite"
       create_option     = "FromImage"
       managed_disk_type = "StandardSSD_LRS"
            }
    
      os_profile {
       computer_name  = var.computer_name[0]
       admin_username = var.admin_username
     }

   os_profile_linux_config {
         disable_password_authentication = true
         ssh_keys {
             path     = "/home/xxxx/.ssh/authorized_xxx"
             key_data = file("~/keys/test/rbeiadmin_test.pub")
           }

              }
      boot_diagnostics {
      enabled=true
        storage_uri = var.boot_url
    
    }
    tags={
    "Name of the Project"=var.project
    "Resource Name"=var.vm_name[0]
    "Environment"=var.environment
}
     }

     #Create appserver VM

resource "azurerm_linux_virtual_machine_scale_set" "appserver_vm01" {
name                  = var.vm_name[1]
 resource_group_name = data.azurerm_resource_group.test_rg_main.name
location=data.azurerm_resource_group.test_rg_main.location
    sku                  = var.vm_size[1]
    instances           = var.instances
    admin_username = var.admin_username
    disable_password_authentication = true

    network_interface {
    name    = data.azurerm_network_interface.appservervm_nic.name
    primary = true

    ip_configuration {
      name      = "IPConfiguration"
      primary   = true
       subnet_id = data.azurerm_subnet.test_subnet.id
    }
    }

  source_image_reference {
    publisher = var.image_publisher
    offer     = var.image_offer
    sku       = var.image_sku
    version   = var.image_version
  }

  data_disk {
  caching = var.data_catching
  create_option = var.stg_create_option
  disk_size_gb         = var.stg_disk_size_gb
  lun = var.datadisk_lun
  storage_account_type = var.storage_account_type

  }
  



admin_ssh_key {
    username   = var.admin_username
    public_key = file("C:/Users/xxxx/keys/test/secondkeymod.pub")
  }
   
os_disk {
    storage_account_type = "StandardSSD_LRS"
    caching              = "ReadWrite"

  }
      boot_diagnostics {
        storage_account_uri = var.boot_url
    
    }
    tags={
    "Name of the Project"=var.project
    "Resource Name"=var.vm_name[0]
    "Environment"=var.environment
}
     }


     #Adding Datadisk
  resource "azurerm_managed_disk" "appserver_vm01_disk" {
  name                 = "appserver_vm01_datadisk01"
  location             = data.azurerm_resource_group.test_rg_main.location
  resource_group_name  = data.azurerm_resource_group.test_rg_main.name
  storage_account_type = var.storage_account_type
  create_option        = var.stg_create_option
  disk_size_gb         = var.stg_disk_size_gb
}

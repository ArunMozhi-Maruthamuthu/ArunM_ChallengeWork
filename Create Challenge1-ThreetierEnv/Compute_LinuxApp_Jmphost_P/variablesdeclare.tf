variable "location"{
    description="Hosted country"
}
variable "environment"{
    description = "Name of the Environment"
}

variable "project"{
    description="Name of the Project"
}

variable "avname"{
    description="Name of the Availability set"
}


variable "image_publisher"{
    description="Storage image parameter"
}

variable "image_offer"{
    description="Storage image parameter"
}

variable "image_sku"{
    description="Storage image parameter"
}

variable "image_version"{
    description="image_version"
}

variable "os_caching"{
    description="Storage image parameter"
}

variable "data_catching"{
    description="data disc image parameter"
}

//The following section creates a VM and attaches the virtual NIC to it.

variable "vm_name" {
  description = "Name of the VM"
 
}
variable "vm_size" {
  description = "vm_size"
}


//Find the VM images in the Azure Marketplace with the Azure CLI tool

//boot diagnosetic: 
variable "boot_url" {
  description = "boot_url"
}

variable "subnet_name" {
  description = "subnet_name"
}
variable "vnetname" {
  description = "vnetname"
}

variable "storage_account_type" {
  description = "storage_account_type"
}

variable "stg_create_option" {
  description = "stg_create_option"
}

variable "stg_disk_size_gb" {
  description = "stg_disk_size_gb"
}

//Windows OS disk by default it is of 128 GB
variable "os_disk_name" {
  description = "os_disk"
}
// Adding additional disk for persistent storage

//Here defined admin uid/pwd and also comupter name
variable "computer_name" {
  description = "name of the computer"
}

variable "admin_username" {
  description = "Username"
  }
variable "datadisk_lun"{
    description="Datadisk parameter"
}

variable "instances"{
    description="instances"
}

variable "datadisk_caching"{
    description="Datadisk parameter"
}
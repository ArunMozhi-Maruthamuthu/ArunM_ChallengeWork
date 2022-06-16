
variable "location" {
  description = "The location/region where the Rg_names to create."
}


variable "vnet_name" {
  description = "Name of the vnet to create"
}

variable "address_space" {
  description = "The address space that is used by the virtual network."
}


variable "Subnet_names" {
  description = "A list of subnets to create."
}

variable "subnet_address" {
  description = "The address to use for the subnet."
}

variable "nsgname" {
  description = "Name of NSG"
}

variable "project"{
    description = "Name of the project"
}

variable "environment"{
    description = "Name of the environment"
}

variable "nicname"{
    description = "Name of the NIC"
}

variable "nicconf"{
    description = "Name of the NIC configuration"
}

variable "pipname"{
    description = "Name of the NIC configuration"
}

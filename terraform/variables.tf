variable "tags" {
  type    = map(string)
  default = {
    env = "testing"
    app = "udacity"
  }
}

variable "resource_group_name" {
  type = string
  default = "rg-udacityproject"
  description = "(Required) The Name which should be used for this Resource Group. Changing this forces a new Resource Group to be created."

  validation {
    condition = length(var.resource_group_name) > 2 && substr(var.resource_group_name,0,3) == "rg-"
    error_message = "The resource group name must more than 2 characters and start with \"rg-\" prefix."
  }
}

variable "location" {
  type = string
  description = "(Required) The Azure Region where the Resource Group should exist. Changing this forces a new Resource Group to be created."
  default = "eastus"
}

variable "nsg_name" {
  type = string
  description = "(Required) Specifies the name of the network security group. Changing this forces a new resource to be created."
  default = "nsg-udacity"
}

variable "vnet_name" {
  type = string
  description = " (Required) The name of the virtual network. Changing this forces a new resource to be created."
  default = "vnet-udacity"
}

variable "snet_name" {
  type = string
  description = "(Required) The name of the subnet"
  default = "snet-udacity"
}

variable "ni_name" {
  type = string
  description = "(Required) The name of the Network Interface. Changing this forces a new resource to be created."
  default = "ni-udacity"
}

variable "public_ip_name" {
  type = string
  description = "(Required) Specifies the name of the Public IP. Changing this forces a new Public IP to be created."
  default = "pi-udacity"
}

variable "vm_linux_names" {
  type = list(string)
  description = "(Required) List names of virtual machine create in VMSS"
  default = [ "vm-linux-1" ]
}

variable "vm_image_id" {
  type = string
  default = "/subscriptions/d381139d-0fa2-4a19-a4a0-0df928a317be/resourceGroups/UDACITY-PROJECT-1/providers/Microsoft.Compute/images/projectUdacity"
}

variable "admin_username" {
  type = string
  description = "(Required) Admin's username of the virtual machine"
  default = "trident"
}

variable "admin_password" {
  type = string
  description = "(Required) Admin's password of the virtual machine"
  default = "Password@@"
  sensitive = true
}

variable "vmss_name" {
  type = string
  description = "(Required) Virtual Machine Scale Set's name"
  default = "vmss-udacity"
}

variable "vm_os_disk_name" {
  type = string
  description = "(Required) OS disk's name"
  default = "osDiskHDD"
}

variable "vm_prefix" {
  type = string
  description = "(Required) prefix of the vm"
  default = "vmUdacity"
}

variable "vm_network_profile" {
  type = string
  description = "(Required) virtual machine network profile name"
  default = "vmNetWorkProfile"
}

variable "vm_sku" {
  type = string
  description = "(Required) Size of the VM"
  default = "Standard_B1ls"
}

variable "vm_tier" {
  type = string
  description = "(Required) Tier of the VM"
  default = "Standard"
}
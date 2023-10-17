provider "azurerm" {
   features {}
}

# Define resource group
resource "azurerm_resource_group" "this" {
  name     = var.resource_group_name
  location = var.location
}

# Define Network
resource "azurerm_virtual_network" "this" {
  name                = var.vnet_name
  location            = var.location
  resource_group_name = azurerm_resource_group.this.name
  address_space       = ["10.0.0.0/16"]
 
  tags = var.tags
}

resource "azurerm_subnet" "this" {
  name                 = var.snet_name
  resource_group_name  = azurerm_resource_group.this.name
  virtual_network_name = azurerm_virtual_network.this.name
  address_prefixes     = ["10.0.1.0/24"]
}

resource "azurerm_network_security_group" "this" {
  name                = var.nsg_name
  location            = var.location
  resource_group_name = azurerm_resource_group.this.name
}

resource "azurerm_network_security_rule" "allow" {
  name = "AllowSubnetTraffic"
  priority = 100
  direction = "Inbound"
  access = "Allow"
  protocol = "*"
  source_port_range = "*"
  destination_port_range = "*"
  source_address_prefix = "*"
  destination_address_prefix = "10.0.1.0/24" # Subnet CIDR
  resource_group_name         = azurerm_resource_group.this.name
  network_security_group_name = azurerm_network_security_group.this.name
}

resource "azurerm_network_security_rule" "deny" {
  name = "DenyAccessFromInternet"
  priority = 110
  direction = "Inbound"
  access = "Deny"
  protocol = "*"
  source_port_range = "*"
  destination_port_range = "*"
  source_address_prefix = "Internet"
  destination_address_prefix = "*"
  resource_group_name         = azurerm_resource_group.this.name
  network_security_group_name = azurerm_network_security_group.this.name
}

# resource "azurerm_network_interface" "this" {
#   name                = var.ni_name
#   location            = azurerm_resource_group.this.location
#   resource_group_name = azurerm_resource_group.this.name

#   ip_configuration {
#     name                          = "internal"
#     subnet_id                     = azurerm_subnet.this.id
#     private_ip_address_allocation = "Dynamic"
#   }
# }

resource "azurerm_public_ip" "this" {
  name                = var.public_ip_name
  resource_group_name = azurerm_resource_group.this.name
  location            = azurerm_resource_group.this.location
  allocation_method   = "Static"

  tags = var.tags
}


# Define VMSS and Load Balancer
resource "azurerm_lb" "this" {
  name                = "test"
  location            = azurerm_resource_group.this.location
  resource_group_name = azurerm_resource_group.this.name

  frontend_ip_configuration {
    name                 = "PublicIPAddress"
    public_ip_address_id = azurerm_public_ip.this.id
  }
}

resource "azurerm_lb_backend_address_pool" "bpepool" {
  loadbalancer_id = azurerm_lb.this.id
  name            = "bep-${var.vm_linux_names[count.index]}"
  count           = length(var.vm_linux_names)
}

resource "azurerm_lb_nat_pool" "lbnatpool" {
  resource_group_name            = azurerm_resource_group.this.name
  name                           = "ssh"
  loadbalancer_id                = azurerm_lb.this.id
  protocol                       = "Tcp"
  frontend_port_start            = 50000
  frontend_port_end              = 50119
  backend_port                   = 22
  frontend_ip_configuration_name = "PublicIPAddress"
}

resource "azurerm_virtual_machine_scale_set" "this" {
  name                = var.vmss_name
  location            = azurerm_resource_group.this.location
  resource_group_name = azurerm_resource_group.this.name

  # automatic rolling upgrade
  automatic_os_upgrade = false
  upgrade_policy_mode  = "Manual"

  sku {
    name     = var.vm_sku
    tier     = var.vm_tier
    capacity = length(var.vm_linux_names)
  }

  storage_profile_image_reference {
    id        = var.vm_image_id
  }

  storage_profile_os_disk {
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

  storage_profile_data_disk {
    lun           = 0
    caching       = "ReadWrite"
    create_option = "Empty"
    disk_size_gb  = 10
  }

  os_profile {
    computer_name_prefix = var.vm_prefix
    admin_username       = var.admin_username
    admin_password       = var.admin_password
  }

  network_profile {
    name    = var.vm_network_profile
    primary = true

    ip_configuration {
      name                                   = "TestIPConfiguration"
      primary                                = true
      subnet_id                              = azurerm_subnet.this.id
       load_balancer_backend_address_pool_ids = azurerm_lb_backend_address_pool.bpepool[*].id
      load_balancer_inbound_nat_rules_ids    = [azurerm_lb_nat_pool.lbnatpool.id]
    }
  }

  tags = var.tags
}

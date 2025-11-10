##############################
# Resource Group
##############################
resource "azurerm_resource_group" "devops" {
  name     = "devops-${terraform.workspace}-rg"
  location = var.location
}

##############################
# Virtual Network
##############################
resource "azurerm_virtual_network" "vnet" {
  name                = "devops-${terraform.workspace}-vnet"
  location            = var.location
  resource_group_name = azurerm_resource_group.devops.name
  address_space       = ["10.0.0.0/16"]
}

##############################
# Subnet
##############################
resource "azurerm_subnet" "subnet" {
  name                 = "devops-${terraform.workspace}-subnet"
  resource_group_name  = azurerm_resource_group.devops.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.1.0/24"]
}

##############################
# Network Security Group
##############################
resource "azurerm_network_security_group" "nsg" {
  name                = "devops-${terraform.workspace}-nsg"
  location            = var.location
  resource_group_name = azurerm_resource_group.devops.name

  security_rule {
    name                       = "SSH"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "Jenkins"
    priority                   = 110
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "8080"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "Sonar"
    priority                   = 120
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "9000"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "Nexus"
    priority                   = 130
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "8081"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}


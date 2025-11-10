resource "azurerm_public_ip" "sonar_public_ip" {
  name                = "sonar-${terraform.workspace}-public-ip"
  resource_group_name = azurerm_resource_group.devops.name
  location            = var.location
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_network_interface" "sonar_nic" {
  name                = "sonar-${terraform.workspace}-nic"
  location            = var.location
  resource_group_name = azurerm_resource_group.devops.name

  ip_configuration {
    name                          = "sonar-ip"
    subnet_id                     = azurerm_subnet.subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.sonar_public_ip.id
  }
}

resource "azurerm_network_interface_security_group_association" "sonar_nsg_assoc" {
  network_interface_id      = azurerm_network_interface.sonar_nic.id
  network_security_group_id = azurerm_network_security_group.nsg.id
}

resource "azurerm_linux_virtual_machine" "sonar_vm" {
  name                = "sonar-${terraform.workspace}"
  resource_group_name = azurerm_resource_group.devops.name
  location            = var.location
  size                = "Standard_B2ms"
  admin_username      = var.admin_username

  network_interface_ids = [azurerm_network_interface.sonar_nic.id]

  admin_ssh_key {
    username   = var.admin_username
    public_key = file(var.ssh_public_key)
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
    disk_size_gb         = 80
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-focal"
    sku       = "20_04-lts"
    version   = "latest"
  }
custom_data = filebase64("${path.module}/scripts/sonar-nexus-install.sh")

}

resource "azurerm_windows_virtual_machine" "vm" {
  admin_password        = "${var.admin_password}"
  admin_username        = "${var.admin_username}"
  location              = "${var.location}"
  name                  = "${var.name}"
  network_interface_ids = [azurerm_network_interface.nic_vm.id]
  resource_group_name   = "${var.resource_group_name}"
  size                  = "Standard_B2s"
  boot_diagnostics {
  }
  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "StandardSSD_LRS"
  }
  source_image_reference {
    offer     = "WindowsServer"
    publisher = "MicrosoftWindowsServer"
    sku       = "2016-datacenter-gensecond"
    version   = "latest"
  }
  depends_on = [
    azurerm_network_interface.nic_vm,
  ]
}

# Define the network interface for the virtual machine
resource "azurerm_network_interface" "nic_vm" {
 name = "nic-${var.name}"
 location = var.location
 resource_group_name = var.resource_group_name
 ip_configuration {
   name = "ipconfig1"
   private_ip_address_allocation = "Dynamic"
   subnet_id = "${var.vnet_subnet_id}"
   public_ip_address_id = azurerm_public_ip.pip.id
 }
}

resource "azurerm_public_ip" "pip" {
 name = "pip-${var.name}"
 resource_group_name = "${var.resource_group_name}"
 location = "${var.location}"
 allocation_method = "Dynamic" 
}
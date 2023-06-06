# Define the virtual machine
resource "azurerm_windows_virtual_machine" "vm" {
 name = var.vm_name
 location = var.location
 resource_group_name = var.rg_name
 network_interface_ids = [azurerm_network_interface.nic_vm.id]
 size = var.vm_size
 admin_username = var.admin_username
 admin_password = var.admin_password

 storage_image_reference {
 publisher = "MicrosoftWindowsServer"
 offer = "WindowsServer"
 sku = "2019-Datacenter"
 version = "latest"
 }

 storage_os_disk {
 name = "${var.vm_name}-os-disk"
 caching = "ReadWrite"
 create_option = "FromImage"
 managed_disk_type = "Premium_LRS"
 }

 storage_data_disk {
 name = "${var.vm_name}-data-disk"
 lun = 0
 caching = "ReadWrite"
 create_option = "Empty"
 disk_size_gb = 32
 managed_disk_type = "Premium_LRS"
 }

 custom_data = <<CUSTOMDATA
<powershell>
Install-WindowsFeature Web-Server -IncludeManagementTools
Set-Service -Name W3SVC -StartupType 'Automatic'
Start-Service -Name W3SVC
</powershell>
CUSTOMDATA
}

# Define the network interface for the virtual machine
resource "azurerm_network_interface" "nic_vm" {
 name = "nic-${var.vm_name}"
 location = var.location
 resource_group_name = var.rg_name

 ip_configuration {
 name = "ipconfig-${var.vm_name}"
 subnet_id = var.vnet_subnet_id
 private_ip_address_allocation = "Dynamic"
 }
}
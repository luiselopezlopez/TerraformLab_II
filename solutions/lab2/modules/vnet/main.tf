# Define the virtual network

resource "azurerm_virtual_network" "vnet" {
 name = "${var.name}"
 address_space = "${var.vnet_address_space}"
 location = "${var.location}"
 resource_group_name = "${var.resource_group_name}"
}
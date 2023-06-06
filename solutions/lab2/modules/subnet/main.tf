# Define the subnet
resource "azurerm_subnet" "subnet" {
 name = "${var.name}"
 virtual_network_name = "${var.virtual_network_name}"
 address_prefixes =  "${var.address_prefixes}"
 resource_group_name = "${var.resource_group_name}"
}
# Define the spoke 1 virtual network peering configuration
resource "azurerm_virtual_network_peering" "spoke" {
 name = "${var.name}"
 resource_group_name = "${var.resource_group_name}"
 virtual_network_name = "${var.hub_vnet_name}"
 remote_virtual_network_id = "${var.spoke_vnet_name}"
 allow_virtual_network_access = true
 allow_forwarded_traffic = false
 use_remote_gateways = false
 allow_gateway_transit = false
}
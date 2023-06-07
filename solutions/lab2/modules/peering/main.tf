# Define the spoke 1 virtual network peering configuration
resource "azurerm_virtual_network_peering" "spoke" {
 name = "${var.name}"
 resource_group_name = "${var.resource_group_name}"
 virtual_network_name = "${var.local_vnet_name}"
 remote_virtual_network_id = "${var.remote_vnet_id}"

 #allow_virtual_network_access = true
 allow_forwarded_traffic = true
 #use_remote_gateways = false
 #allow_gateway_transit = false

}
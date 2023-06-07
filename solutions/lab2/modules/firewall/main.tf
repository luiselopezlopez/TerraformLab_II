# Define the Azure Firewall
resource "azurerm_firewall" "firewall" {
 name = "${var.name}"
 location = "${var.location}"
 resource_group_name = "${var.resource_group_name}"
 sku_name          = "AZFW_VNet"
 sku_tier          = "Standard"
 firewall_policy_id = "${var.firewall_policy_id}"
 ip_configuration {
    name = "firewall-ip-config"
    subnet_id = "${var.fw_subnet_id}"
    public_ip_address_id = "${var.fw_public_ip_id}"
 }
}

resource "azurerm_firewall_policy" "firewallPolicy" {
  location                 = "${var.location}"
  name                     = "default"
  resource_group_name      = "${var.resource_group_name}"
  threat_intelligence_mode = "Alert"
  dns {
    proxy_enabled = true
  }
}

resource "azurerm_firewall_policy_rule_collection_group" "policy_rule_collection" {
  firewall_policy_id = azurerm_firewall_policy.firewallPolicy.id
  name               = "DefaultNetworkRuleCollectionGroup"
  priority           = 400
  network_rule_collection {
    action   = "Allow"
    name     = "AllowInternet"
    priority = 64000
    rule {
      destination_addresses = ["*"]
      destination_ports     = ["*"]
      name                  = "AllowInternet"
      protocols             = ["Any"]
      source_addresses      = ["*"]
    }
  }
  depends_on = [
    azurerm_firewall_policy.firewallPolicy
  ]
}
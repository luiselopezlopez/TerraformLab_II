resource "azurerm_firewall_policy" "firewallPolicy" {
  location                 = "${var.location}"
  name                     = "default"
  resource_group_name      = "${var.resource_group_name}"
  threat_intelligence_mode = "Off"
  dns {
    proxy_enabled = true
  }
}

resource "azurerm_firewall_policy_rule_collection_group" "res-3" {
  firewall_policy_id = azurerm_firewall_policy.firewallPolicy.id
  name               = "DefaultNetworkRuleCollectionGroup"
  priority           = 200
  network_rule_collection {
    action   = "Deny"
    name     = "Default"
    priority = 65000
    rule {
      destination_addresses = ["*"]
      destination_ports     = ["1-65000"]
      name                  = "DenyAll"
      protocols             = ["TCP", "UDP", "ICMP", "Any"]
      source_addresses      = ["*"]
    }
  }
  network_rule_collection {
    action   = "Allow"
    name     = "AllowInternet"
    priority = 64000
    rule {
      destination_addresses = ["*"]
      destination_ports     = ["1-65000"]
      name                  = "AllowInternet"
      protocols             = ["TCP", "UDP", "ICMP", "Any"]
      source_addresses      = ["*"]
    }
  }
  depends_on = [
    azurerm_firewall_policy.firewallPolicy
  ]
}
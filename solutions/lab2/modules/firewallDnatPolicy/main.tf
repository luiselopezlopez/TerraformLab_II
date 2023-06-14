resource "azurerm_firewall_policy_rule_collection_group" "policy_rule_dnat_collection" {
  firewall_policy_id = "${var.policy_id}"
  name               = "DefaultDnatRuleCollectionGroup"
  priority           = 100
  nat_rule_collection {
    action   = "Dnat"
    name     = "${var.ruleCollectionName}"
    priority = "${var.rulePriority}"
    rule {
      destination_address = "${var.destinationAddress}"
      destination_ports   = "${var.destinationPorts}"
      name                = "${var.ruleName}"
      protocols           = "${var.protocol}"
      source_addresses    = "${var.sourceAddress}"
      translated_address  = "${var.translatedAddress}"
      translated_port     = "${var.translatedPort}"
    }
  }
}
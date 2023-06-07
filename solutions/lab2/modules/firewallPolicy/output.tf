# Define output parameter for Firewall Policy ID
output "id" {
    value = azurerm_firewall_policy.firewallPolicy.id
}

# Define output parameter for subnet ID
output "subnet_id" {
 value = azurerm_subnet.subnet.id
}
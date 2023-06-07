
resource "azurerm_route_table" "route_table" {
  name                = "${var.name}"
  resource_group_name = "${var.resource_group_name}"
  location            = "${var.location}"
}


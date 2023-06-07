# Define the hub virtual subnet resource group
resource "azurerm_resource_group" "hub" {
 name = var.hub_vnet_name
 location = var.azure_region
}

# Define the hub virtual network
module "hub_vnet" {
 source = "./modules/vnet"

 name = var.hub_vnet_name
 vnet_address_space = var.hub_vnet_addressspace
 resource_group_name = azurerm_resource_group.hub.name
 location = var.azure_region
 depends_on = [ azurerm_resource_group.hub ]
}

# Define the hub firewall subnet in the virtual network
module "hub_firewall_subnet" {
 source = "./modules/subnet"

 name = var.hub_subnet_name
 address_prefixes = ["10.0.1.0/24"]
 virtual_network_name = var.hub_vnet_name
 resource_group_name = azurerm_resource_group.hub.name
 depends_on = [ module.hub_vnet ]
}


# Define the public IP address for the Azure Firewall
resource "azurerm_public_ip" "hub_fw_public_ip" {
 name = var.hub_fw_public_ip_name
 location = var.azure_region
 resource_group_name = azurerm_resource_group.hub.name
 allocation_method = "Static"
 sku = "Standard"
 depends_on = [ module.hub_vnet ]
}


# Define the Azure Firewall in the hub virtual network
module "hub_firewall" {
 source = "./modules/firewall"

 name = var.hub_firewall_name
 resource_group_name = azurerm_resource_group.hub.name
 fw_subnet_id = module.hub_firewall_subnet.subnet_id
 fw_public_ip_id = azurerm_public_ip.hub_fw_public_ip.id
 location = var.azure_region
 allowed_fw_ports = [var.hub_fw_allow_ports]
 depends_on = [ 
    module.hub_firewall_subnet, 
    azurerm_public_ip.hub_fw_public_ip    
 ]
}

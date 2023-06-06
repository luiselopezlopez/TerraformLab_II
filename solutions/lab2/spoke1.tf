# Define the spoke 1 virtual network resource group
resource "azurerm_resource_group" "spoke_1" {
 name = var.spoke1_vnet_name
 location = var.azure_region
}

# Define the spoke 1 virtual network
module "spoke1_vnet" {
 source = "./modules/vnet"

 name = var.spoke1_vnet_name
 vnet_address_space = ["10.1.0.0/16"]
 resource_group_name = azurerm_resource_group.spoke_1.name
 location = var.azure_region
}

# Define the spoke 1 subnet in the virtual network
module "spoke1_subnet" {
 source = "./modules/subnet"

 name = var.spoke1_subnet_name
 address_prefixes = ["10.1.0.0/24"]
 virtual_network_name = var.spoke1_vnet_name
 resource_group_name = azurerm_resource_group.spoke_1.name
 depends_on = [ module.spoke1_vnet ]
}

module "spoke1_peering" {
    source = "./modules/peering"

    name = format ("peering-%s-%s",var.hub_vnet_name,var.spoke1_vnet_name)
    resource_group_name = azurerm_resource_group.hub.name
    hub_vnet_name = var.hub_vnet_name
    spoke_vnet_name = module.spoke1_vnet.id

}

/*
# Define the Windows virtual machine in spoke 1 virtual network subnet
module "vm1" {
 source = "./modules/vm"

 vm_name = "vm1"
 rg_name = azurerm_resource_group.spoke_1.name
 location = var.azure_region
 vm_size = var.vm_size
 admin_username = var.admin_username
 admin_password = var.admin_password
 vnet_subnet_id = module.spoke1_subnet.subnet_id
}
*/
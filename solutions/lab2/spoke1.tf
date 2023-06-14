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
 depends_on = [ azurerm_resource_group.spoke_1 ]
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

module "peering-spoke1-hub" {
    source = "./modules/peering"

    name = format ("peering-%s-%s",var.spoke1_vnet_name,var.hub_vnet_name)
    resource_group_name = azurerm_resource_group.spoke_1.name
    local_vnet_name = var.spoke1_vnet_name
    remote_vnet_id = module.hub_vnet.id
    depends_on = [ module.hub_vnet,module.spoke1_vnet ]

}

module "route_table_spoke1-hub" {
    source = "./modules/route_table"

    name = "rt-spoke1-hub"
    resource_group_name = azurerm_resource_group.spoke_1.name
    location = var.azure_region   
}

module "route_default_spoke1-hub" {
    source = "./modules/route"

    name = "default"
    resource_group_name = azurerm_resource_group.spoke_1.name
    route_table_name = module.route_table_spoke1-hub.route_table_name
    address_prefix = "0.0.0.0/0"
    next_hop_type = "VirtualAppliance"
    next_hop_in_ip_address = module.hub_firewall.private_ip_address

}

module "route_table_association_spoke1_hub" {
    source = "./modules/route_table_association"
    subnet_id = module.spoke1_subnet.subnet_id
    route_table_id = module.route_table_spoke1-hub.route_table_id
    depends_on = [  
        module.route_table_spoke1-hub,
        module.spoke1_subnet        
        ]
}


# Define the Windows virtual machine in spoke 1 virtual network subnet
module "vm1" {
 source = "./modules/vm"

 name = "vm1"
 resource_group_name = azurerm_resource_group.spoke_1.name
 location = var.azure_region
 admin_username = var.admin_username
 admin_password = var.admin_password
 vnet_subnet_id = module.spoke1_subnet.subnet_id
}

module "firewallDnatPolicy"{
    source ="./modules/firewallDnatPolicy"
    policy_id= module.hub_firewall_policy.id
    ruleCollectionName = "InboundAccess"
    rulePriority = 100
    destinationAddress = azurerm_public_ip.hub_fw_public_ip.ip_address
    destinationPorts = ["3389"]
    ruleName = "RDP"
    protocol = ["TCP"]
    sourceAddress = ["*"]
    translatedAddress = module.vm1.privateIPAddress
    translatedPort = 3389

    depends_on = [ module.hub_firewall_policy ]

}

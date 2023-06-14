## Building the Spoke Network

1. Create a file named *spoke.tf* with this code.
    
    ```
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
    ```
2. Add the terraform parameteters. 
    - In ***variables.tf*** in the root directory add:
        ```
        variable "spoke1_vnet_name" {
            description = "The name of the Spoke 1 Virtual Network."
            default = "spoke1"
        }

        variable "spoke1_subnet_name" {
            description = "The name of the Spoke 1 subnet."
            default = "subnet"
        }
        ```

    - In ***terraform.tfvars*** add:
        ```
        spoke1_vnet_name = "spoke1"
        spoke1_subnet_name = "subnet"

        ```
2. Configure the peerings between Hub and Spoke subnet
    - In *modules* create a folder named *peering* and inside it, two files
        1. **main.tf**
            ```
            resource "azurerm_virtual_network_peering" "spoke" {
                name = "${var.name}"
                resource_group_name = "${var.resource_group_name}"
                virtual_network_name = "${var.local_vnet_name}"
                remote_virtual_network_id = "${var.remote_vnet_id}"

                #allow_virtual_network_access = true
                allow_forwarded_traffic = true
                #use_remote_gateways = false
                #allow_gateway_transit = false
            }
            ```

        2. **variables.tf**
            ```
            variable "resource_group_name" {
                type = string
            }
            variable "name" {
                type = string
            }
            variable "remote_vnet_id" {
                type = string
            }
            variable "local_vnet_name" {
                type = string
            }
            ```
    - In ***hub.tf*** file write
        ```
        module "peering-hub-spoke1" {
            source = "./modules/peering"
            name = format ("peering-%s-%s",var.hub_vnet_name,var.spoke1_vnet_name)
            resource_group_name = azurerm_resource_group.hub.name
            local_vnet_name = var.hub_vnet_name
            remote_vnet_id = module.spoke1_vnet.id
            depends_on = [ module.hub_vnet,module.spoke1_vnet ]
        }
        ```
    - In ***spoke.tf*** file write
        ```
        module "peering-spoke1-hub" {
            source = "./modules/peering"
            name = format ("peering-%s-%s",var.spoke1_vnet_name,var.hub_vnet_name)
            resource_group_name = azurerm_resource_group.spoke_1.name
            local_vnet_name = var.spoke1_vnet_name
            remote_vnet_id = module.hub_vnet.id
            depends_on = [ module.hub_vnet,module.spoke1_vnet ]
        }
        ```

3. Configure routing in ***spoke.tf**
    - In *modules* create a folder named *route_table* and inside it, three files
        1. **main.tf**
            ```
            resource "azurerm_route_table" "route_table" {
                name                = "${var.name}"
                resource_group_name = "${var.resource_group_name}"
                location            = "${var.location}"
            }
            ```

        2. **output.tf**
            ```
            output "route_table_id" {
                value = azurerm_route_table.route_table.id
            }
            output "route_table_name" {
                value = azurerm_route_table.route_table.name
            }
            ```

        2. **variables.tf**
            ```
            variable "name" {
                description = "Name of the route table."
                type        = string
            }
            variable "resource_group_name" {
                description = "Name of the resource group."
                type        = string
            }
            variable "location" {
                type = string
            }
            ```

    - In *modules* create a folder named *route* and inside it, two files
        1. **main.tf**
            ```
            resource "azurerm_route" "route" {
                name                   = "${var.name}"
                resource_group_name    = "${var.resource_group_name}"
                route_table_name       = "${var.route_table_name}"
                address_prefix         = "${var.address_prefix}"
                next_hop_type          = "${var.next_hop_type}"
                next_hop_in_ip_address = "${var.next_hop_in_ip_address}"
            }
            ```

        2. **variables.tf**
            ```
            variable "resource_group_name" {
                type = string
            }
            variable "name" {
                type = string
            }
            variable "route_table_name"{
                type = string
            }
            variable "address_prefix"{
                type = string
            }
            variable "next_hop_type"{
                type = string
            }
            variable "next_hop_in_ip_address"{
                type = string
            }
            ```

    - In *modules* create a folder named *route_table_association* and inside it, two files
        1. **main.tf**
            ```
            resource "azurerm_subnet_route_table_association" "route_association" {
                subnet_id      = "${var.subnet_id}"
                route_table_id = "${var.route_table_id}"
            }
            ```

        2. **variables.tf**
            ```
            variable "subnet_id" {
                type        = string
            }

            variable "route_table_id" {
                type        = string
            }
            ```
    - In ***peering.tf*** write

        ```
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
        ```

4. Deploy the terraform into the Azure Subscription
    ```
    az login
    terraform init
    terraform plan -var-file=".\terraform.tfvars"
    terraform apply -var-file=".\terraform.tfvars" -auto-approve
    ```
    Check the result in Azure.
    

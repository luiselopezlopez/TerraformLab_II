# Configuring Spoke Routing

1. In *modules* create a folder named *route_table* and inside it, three files
    - **main.tf**
        ```
        resource "azurerm_route_table" "route_table" {
            name                = "${var.name}"
            resource_group_name = "${var.resource_group_name}"
            location            = "${var.location}"
        }
        ```

    - **output.tf**
        ```
        output "route_table_id" {
            value = azurerm_route_table.route_table.id
        }
        output "route_table_name" {
            value = azurerm_route_table.route_table.name
        }
        ```

    - **variables.tf**
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

2. In *modules* create a folder named *route* and inside it, two files
    - **main.tf**
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

    - **variables.tf**
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

3. In *modules* create a folder named *route_table_association* and inside it, two files
    - **main.tf**
        ```
        resource "azurerm_subnet_route_table_association" "route_association" {
            subnet_id      = "${var.subnet_id}"
            route_table_id = "${var.route_table_id}"
        }
        ```

    - **variables.tf**
        ```
        variable "subnet_id" {
            type        = string
        }

        variable "route_table_id" {
            type        = string
        }
        ```
4. In ***spoke.tf*** write

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

5. Deploy the terraform into the Azure Subscription
    ```
    az login
    terraform init
    terraform plan -var-file=".\terraform.tfvars"
    terraform apply -var-file=".\terraform.tfvars" -auto-approve
    ```
    Check the result in Azure.
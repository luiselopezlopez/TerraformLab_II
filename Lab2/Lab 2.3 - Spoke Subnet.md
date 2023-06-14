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


3. Deploy the terraform into the Azure Subscription
    ```
    az login
    terraform init
    terraform plan -var-file=".\terraform.tfvars"
    terraform apply -var-file=".\terraform.tfvars" -auto-approve
    ```
    Check the result in Azure.
    
[Back to Index](/README.md)
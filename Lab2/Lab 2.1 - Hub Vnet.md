## Creating Hub Network

1. Copy *backend.tf* from the previous laboratory into the *\terraform* directory.
2. Create a file called *hub.tf*
    ```
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
    ```
3. Create a file called *variables.tf*
    ```
    variable "azure_region" {
        description = "The Azure region in which to configure the resources."
        default = "eastus"
    }

    variable "hub_vnet_name" {
        description = "The name of the Hub Virtual Network."
        default = "hub"
    }

    variable "hub_vnet_addressspace"{
        description = "Hub vnet address space"
        type = list
        default =["10.0.0.0/16"]
    }

    variable "hub_subnet_name" {
        description = "The name of the Hub Firewall subnet."
        default = "fw-subnet"
    }
    ```
4. Create a file called *terraform.tfvars* 
    ```
    azure_region = "northeurope"
    hub_vnet_name = "hub"
    hub_vnet_addressspace =["10.0.0.0/16"]
    hub_subnet_name = "AzureFirewallSubnet"
    ```
5. Create a subdirectory called *modules*
6. Create a subdirectory called *vnet* inside *modules*
7. Inside the directory *modules\vnet* create 3 files
    - main.tf
    ```
    resource "azurerm_virtual_network" "vnet" {
        name = "${var.name}"
        address_space = "${var.vnet_address_space}"
        location = "${var.location}"
        resource_group_name = "${var.resource_group_name}"
    }
    ```

    - output.tf
    ```
    output "id" {
        value = azurerm_virtual_network.vnet.id
    }
    ```

    - variables.tf
    ```
    variable "resource_group_name" {
        type = string
    }
    variable "name" {
        type = string
    }
    variable "location" {
        type = string
    }
    variable "vnet_address_space" {
        type = list
    }
    ```

8. Create a subdirectory called *subnet* inside *modules*
9. Inside the directory *modules\subnet* create 3 files
    - main.tf
    ```
    resource "azurerm_subnet" "subnet" {
        name = "${var.name}"
        virtual_network_name = "${var.virtual_network_name}"
        address_prefixes =  "${var.address_prefixes}"
        resource_group_name = "${var.resource_group_name}"
    }
    ```
    - output.tf
    ```
    output "subnet_id" {
        value = azurerm_subnet.subnet.id
    }
    ```

    - variables.tf
    ```
    variable "resource_group_name" {
        type = string
    }
    variable "name" {
        type = string
    }
    variable "virtual_network_name" {
        type = string
    }
    variable "address_prefixes" {
        type = list
    }

    ```
10. Deploy the terraform into the Azure Subscription
    ```
    az login
    terraform init
    terraform plan -var-file=".\terraform.tfvars"
    terraform apply -var-file=".\terraform.tfvars" -auto-approve
    ```
    Check the result in Azure.
    

## Creating the Firewall

1. Add the following code to *hub.tf*
    ```
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
        firewall_policy_id = module.hub_firewall_policy.id
        location = var.azure_region
        allowed_fw_ports = [var.hub_fw_allow_ports]
        depends_on = [ 
            module.hub_firewall_subnet, 
            azurerm_public_ip.hub_fw_public_ip,
            module.hub_firewall_policy
        ]
    }

    module "hub_firewall_policy" {
        source= "./modules/firewallPolicy"

        resource_group_name = azurerm_resource_group.hub.name
        location = var.azure_region
    }
    ```
2. Add the following lines to *variables.tf*
    ```
    variable "hub_firewall_name" {
        description = "The name of the Azure Firewall in the Hub VNet."
        default = "FW-HUB"
    }

    variable "hub_fw_public_ip_name" {
        description = "The name of the public IP address for the Hub VNet Azure Firewall."
        default = "fw-public-ip"
    }
    ```
3. Add the following lines to *terraform.tfvar*
    ```
    hub_firewall_name = "FW-HUB"
    hub_fw_public_ip_name = "fw-public-ip"
    ```

4. In *modules* create a folder named *firewall* and inside it, three files
    - main.tf
    ```
    resource "azurerm_firewall" "firewall" {
        name = "${var.name}"
        location = "${var.location}"
        resource_group_name = "${var.resource_group_name}"
        sku_name          = "AZFW_VNet"
        sku_tier          = "Standard"
        firewall_policy_id = "${var.firewall_policy_id}"
        ip_configuration {
            name = "firewall-ip-config"
            subnet_id = "${var.fw_subnet_id}"
            public_ip_address_id = "${var.fw_public_ip_id}"
        }
    }
    ```

    - output.tf
    ```
    output "private_ip_address" {
        value = azurerm_firewall.firewall.ip_configuration[0].private_ip_address
    }
    ```

    - variables.tv
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
    variable "allowed_fw_ports" {
        type = list
    }
    variable "fw_subnet_id"{
        type = string
    }
    variable "fw_public_ip_id" {
        type = string 
    }
    variable "firewall_policy_id" {
        type = string 
    }
    ```
5. In *modules* create a folder named *firewallPolicy* and inside it, three files
    - main.tf
    ```
    resource "azurerm_firewall_policy" "firewallPolicy" {
        location                 = "${var.location}"
        name                     = "default"
        resource_group_name      = "${var.resource_group_name}"
        threat_intelligence_mode = "Alert"
        dns {
            proxy_enabled = true
        }
    }

    resource "azurerm_firewall_policy_rule_collection_group" "policy_rule_collection" {
        firewall_policy_id = azurerm_firewall_policy.firewallPolicy.id
        name               = "DefaultNetworkRuleCollectionGroup"
        priority           = 400
        network_rule_collection {
            action   = "Allow"
            name     = "AllowInternet"
            priority = 64000
            rule {
            destination_addresses = ["*"]
            destination_ports     = ["*"]
            name                  = "AllowInternet"
            protocols             = ["Any"]
            source_addresses      = ["*"]
            }
        }
        depends_on = [
            azurerm_firewall_policy.firewallPolicy
        ]
    }
    ```
    
    - output.tf
    ```
    output "id" {
        value = azurerm_firewall_policy.firewallPolicy.id
    }
    ```

    - variables.tf
    ```
    variable "resource_group_name" {
        type = string
    }

    variable "location" {
        type = string
    }    
    ```



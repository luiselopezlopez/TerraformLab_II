# Enable RDP DNAT rule in Firewall

1. In *modules* create a folder named *firewallDnatPolicy* and inside it, two files 

    - main.tf
        ```
        resource "azurerm_firewall_policy_rule_collection_group" "policy_rule_dnat_collection" {
            firewall_policy_id = "${var.policy_id}"
            name               = "DefaultDnatRuleCollectionGroup"
            priority           = 100
            nat_rule_collection {
                action   = "Dnat"
                name     = "${var.ruleCollectionName}"
                priority = "${var.rulePriority}"
                rule {
                destination_address = "${var.destinationAddress}"
                destination_ports   = "${var.destinationPorts}"
                name                = "${var.ruleName}"
                protocols           = "${var.protocol}"
                source_addresses    = "${var.sourceAddress}"
                translated_address  = "${var.translatedAddress}"
                translated_port     = "${var.translatedPort}"
                }
            }
        }
        
    - variables.tf
        ```
        variable "policy_id" {
            type = string
        }
        variable "ruleCollectionName" {
            type = string
        }
        variable "rulePriority" {
            type = string
        }    
        variable "destinationAddress" {
            type = string
        }    
        variable "destinationPorts" {
            type = list
        }    
        variable "ruleName" {
            type = string
        }    
        variable "protocol" {
            type = list
        }    
        variable "sourceAddress" {
            type = list
        }    
        variable "translatedAddress" {
            type = string
        }    
        variable "translatedPort" {
            type = string
        }
        ```
2. In ***spoke.tf*** add
    ```
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
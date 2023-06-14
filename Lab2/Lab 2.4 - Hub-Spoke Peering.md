# Configure Peering

1. Configure the peerings between Hub and Spoke subnet
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

2. Deploy the terraform into the Azure Subscription
    ```
    az login
    terraform init
    terraform plan -var-file=".\terraform.tfvars"
    terraform apply -var-file=".\terraform.tfvars" -auto-approve
    ```
    Check the result in Azure.

[Back to Index](/README.md)
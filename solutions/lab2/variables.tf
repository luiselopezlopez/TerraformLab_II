# Define the required input variables

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

variable "hub_firewall_name" {
 description = "The name of the Azure Firewall in the Hub VNet."
 default = "FW-HUB"
}

variable "hub_fw_public_ip_name" {
 description = "The name of the public IP address for the Hub VNet Azure Firewall."
 default = "fw-public-ip"
}

variable "hub_fw_allow_ports" {
 description = "The list of firewall ports allowed for the Hub Firewall."
 type = list(number)
 default = [80, 443, 3389]
}

variable "spoke1_vnet_name" {
 description = "The name of the Spoke 1 Virtual Network."
 default = "spoke1"
}

variable "spoke1_subnet_name" {
 description = "The name of the Spoke 1 subnet."
 default = "subnet"
}

variable "vm_size" {
 description = "The size of the Windows virtual machine."
 default = "Standard_B2s"
}

variable "admin_username" {
 description = "The admin username for the Windows virtual machine."
 default = "adminuser"
}

variable "admin_password" {
 description = "The admin password for the Windows virtual machine."
 default = "AdminPassword123!"
}
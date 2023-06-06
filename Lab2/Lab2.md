First, let's create a file called `variables.tf` to define the required input variables:

```
# Define the required input variables

variable "azure_region" {
 description = "The Azure region in which to configure the resources."
 default = "eastus"
}

variable "hub_vnet_name" {
 description = "The name of the Hub Virtual Network."
 default = "hub"
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
```

Next, let's create a file called `hub.tf` to define the hub virtual network and Azure Firewall:

```
# Define the hub virtual network resource group
resource "azurerm_resource_group" "hub" {
 name = var.hub_vnet_name
 location = var.azure_region
}

# Define the hub virtual network
module "hub_vnet" {
 source = "./modules/vnet"

 vnet_name = var.hub_vnet_name
 vnet_address_space = "10.0.0.0/16"
 rg_name = azurerm_resource_group.hub.name
 location = var.azure_region
}

# Define the hub firewall subnet in the virtual network
module "hub_firewall_subnet" {
 source = "./modules/subnet"

 subnet_name = var.hub_subnet_name
 subnet_address_space = "10.0.1.0/24"
 vnet_name = var.hub_vnet_name
 rg_name = azurerm_resource_group.hub.name
}

# Define the public IP address for the Azure Firewall
resource "azurerm_public_ip" "hub_fw_public_ip" {
 name = var.hub_fw_public_ip_name
 location = var.azure_region
 resource_group_name = azurerm_resource_group.hub.name
 allocation_method = "Static"
}

# Define the Azure Firewall in the hub virtual network
module "hub_firewall" {
 source = "./modules/firewall"

 firewall_name = var.hub_firewall_name
 rg_name = azurerm_resource_group.hub.name
 fw_subnet_id = module.hub_firewall_subnet.subnet_id
 fw_public_ip_id = azurerm_public_ip.hub_fw_public_ip.id
 location = var.azure_region
 allowed_fw_ports = var.hub_fw_allow_ports
}
```
# Define the hub virtual network resource group
resource "azurerm_resource_group" "hub" {
 name = var.hub_vnet_name
 location = var.azure_region
}

# Define the hub virtual network
module "hub_vnet" {
 source = "./modules/vnet"

 vnet_name = var.hub_vnet_name
 vnet_address_space = "10.0.0.0/16"
 rg_name = azurerm_resource_group.hub.name
 location = var.azure_region
}

# Define the hub firewall subnet in the virtual network
module "hub_firewall_subnet" {
 source = "./modules/subnet"

 subnet_name = var.hub_subnet_name
 subnet_address_space = "10.0.1.0/24"
 vnet_name = var.hub_vnet_name
 rg_name = azurerm_resource_group.hub.name
}

# Define the public IP address for the Azure Firewall
resource "azurerm_public_ip" "hub_fw_public_ip" {
 name = var.hub_fw_public_ip_name
 location = var.azure_region
 resource_group_name = azurerm_resource_group.hub.name
 allocation_method = "Static"
}

# Define the Azure Firewall in the hub virtual network
module "hub_firewall" {
 source = "./modules/firewall"

 firewall_name = var.hub_firewall_name
 vnet_name = var.hub_vnet_name
 rg_name = azurerm_resource_group.hub.name
 fw_subnet_id = module.hub_firewall_subnet.subnet_id
 fw_public_ip_id = azurerm_public_ip.hub_fw_public_ip.id
 allowed_fw_ports = var.hub_fw_allow_ports
}
```

Next, let's create a file called `spoke1.tf` to define the spoke1 virtual network and Windows virtual machine:

```
# Define the spoke 1 virtual network resource group
resource "azurerm_resource_group" "spoke_1" {
 name = var.spoke1_vnet_name
 location = var.azure_region
}

# Define the spoke 1 virtual network
module "spoke1_vnet" {
 source = "./modules/vnet"

 vnet_name = var.spoke1_vnet_name
 vnet_address_space = "10.1.0.0/16"
 rg_name = azurerm_resource_group.spoke_1.name
 location = var.azure_region
}

# Define the spoke 1 subnet in the virtual network
module "spoke1_subnet" {
 source = "./modules/subnet"

 subnet_name = var.spoke1_subnet_name
 subnet_address_space = "10.1.0.0/24"
 vnet_name = var.spoke1_vnet_name
 rg_name = azurerm_resource_group.spoke_1.name
}

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
```

Finally, let's create a folder called `modules` and define the following module files inside this folder:

`modules/vnet/main.tf`
```
# Define the virtual network
resource "azurerm_virtual_network" "vnet" {
 name = var.vnet_name
 address_space = [var.vnet_address_space]
 location = var.location
 resource_group_name = var.rg_name
}
```

`modules/subnet/main.tf`
```
# Define the subnet
resource "azurerm_subnet" "subnet" {
 name = var.subnet_name
 virtual_network_name = var.vnet_name
 address_prefixes = [var.subnet_address_space]
 resource_group_name = var.rg_name
}
```

`modules/firewall/main.tf`
```
# Define the Azure Firewall
resource "azurerm_firewall" "firewall" {
 name = var.firewall_name
 location = var.location
 resource_group_name = var.rg_name

 ip_configuration {
 name = "firewall-ip-config"
 subnet_id = var.fw_subnet_id
 public_ip_address_id = var.fw_public_ip_id
 }

 dynamic "network_rule_collection" {
 for_each = var.allowed_fw_ports
 content {
 name = "allow-access-to-port-${network_rule_collection.key}"
 priority = network_rule_collection.key
 action = "Allow"
 source_addresses = ["Internet"]
 source_ports = ["*"]
 destination_ports = [network_rule_collection.value]
 destination_addresses = ["*"]
 protocol = "Tcp"
 }
 }
}
```

`modules/vm/main.tf`
```
# Define the virtual machine
resource "azurerm_windows_virtual_machine" "vm" {
 name = var.vm_name
 location = var.location
 resource_group_name = var.rg_name
 network_interface_ids = [azurerm_network_interface.nic_vm.id]
 size = var.vm_size
 admin_username = var.admin_username
 admin_password = var.admin_password

 storage_image_reference {
 publisher = "MicrosoftWindowsServer"
 offer = "WindowsServer"
 sku = "2019-Datacenter"
 version = "latest"
 }

 storage_os_disk {
 name = "${var.vm_name}-os-disk"
 caching = "ReadWrite"
 create_option = "FromImage"
 managed_disk_type = "Premium_LRS"
 }

 storage_data_disk {
 name = "${var.vm_name}-data-disk"
 lun = 0
 caching = "ReadWrite"
 create_option = "Empty"
 disk_size_gb = 32
 managed_disk_type = "Premium_LRS"
 }

 custom_data = <<CUSTOMDATA
<powershell>
Install-WindowsFeature Web-Server -IncludeManagementTools
Set-Service -Name W3SVC -StartupType 'Automatic'
Start-Service -Name W3SVC
</powershell>
CUSTOMDATA
}

# Define the network interface for the virtual machine
resource "azurerm_network_interface" "nic_vm" {
 name = "nic-${var.vm_name}"
 location = var.location
 resource_group_name = var.rg_name

 ip_configuration {
 name = "ipconfig-${var.vm_name}"
 subnet_id = var.vnet_subnet_id
 private_ip_address_allocation = "Dynamic"
 }
}
```

With the above files placed in the correct locations, you can now define your input variables in a `terraform.tfvars` file in your working directory:

```
# terraform.tfvars

azure_region = "eastus"
hub_vnet_name = "hub"
hub_subnet_name = "fw-subnet"
hub_firewall_name = "FW-HUB"
hub_fw_public_ip_name = "fw-public-ip"
hub_fw_allow_ports = [80, 443, 3389]
spoke1_vnet_name = "spoke1"
spoke1_subnet_name = "subnet"
vm_size = "Standard_B2s"
admin_username = "adminuser"
admin_password = "AdminPassword123!"
```

You can then run `terraform init`, `terraform plan`, and `terraform apply` to create the infrastructure in Azure with your configuration.
# terraform.tfvars

azure_region = "northeurope"
hub_vnet_name = "hub"
hub_vnet_addressspace =["10.0.0.0/16"]
hub_subnet_name = "AzureFirewallSubnet"
hub_firewall_name = "FW-HUB"
hub_fw_public_ip_name = "fw-public-ip"
hub_fw_allow_ports = [80, 443, 3389]
spoke1_vnet_name = "spoke1"
spoke1_subnet_name = "subnet"
vm_size = "Standard_B2s"
admin_username = "adminuser"
admin_password = "AdminPassword123!"

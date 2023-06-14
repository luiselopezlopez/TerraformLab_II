# Create a Virtual Machine

1.  In *modules* create a folder named *vm* and inside it, two files 
    - **main.tf**
        ```
        resource "azurerm_windows_virtual_machine" "vm" {
            admin_password        = "${var.admin_password}"
            admin_username        = "${var.admin_username}"
            location              = "${var.location}"
            name                  = "${var.name}"
            network_interface_ids = [azurerm_network_interface.nic_vm.id]
            resource_group_name   = "${var.resource_group_name}"
            size                  = "Standard_B2s"
            boot_diagnostics {
            }
            os_disk {
                caching              = "ReadWrite"
                storage_account_type = "StandardSSD_LRS"
            }
            source_image_reference {
                offer     = "WindowsServer"
                publisher = "MicrosoftWindowsServer"
                sku       = "2016-datacenter-gensecond"
                version   = "latest"
            }
            depends_on = [
                azurerm_network_interface.nic_vm,
            ]
        }

        # Define the network interface for the virtual machine
        resource "azurerm_network_interface" "nic_vm" {
            name = "nic-${var.name}"
            location = var.location
            resource_group_name = var.resource_group_name
            ip_configuration {
            name = "ipconfig1"
            private_ip_address_allocation = "Dynamic"
            subnet_id = "${var.vnet_subnet_id}"
            public_ip_address_id = azurerm_public_ip.pip.id
            }
        }

        resource "azurerm_public_ip" "pip" {
            name = "pip-${var.name}"
            resource_group_name = "${var.resource_group_name}"
            location = "${var.location}"
            allocation_method = "Dynamic" 
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
        variable "location"{
            type = string
        }
        variable "admin_username" {
            type = string
        }
        variable "admin_password" {
            type = string
        }
        variable "vnet_subnet_id" {
            type = string
        }
        ```
    
2. In ***spoke.tf*** add
    ```
    module "vm1" {
        source = "./modules/vm"
        name = "vm1"
        resource_group_name = azurerm_resource_group.spoke_1.name
        location = var.azure_region
        admin_username = var.admin_username
        admin_password = var.admin_password
        vnet_subnet_id = module.spoke1_subnet.subnet_id
    }
    ```

3. In ***variables.tf*** add:
    ```
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

4. In **terraform.tfvars*** add:
    ```
    vm_size = "Standard_B2s"
    admin_username = "adminuser"
    admin_password = "AdminPassword123!"
    ```

5. Deploy the terraform into the Azure Subscription
    ```
    az login
    terraform init
    terraform plan -var-file=".\terraform.tfvars"
    terraform apply -var-file=".\terraform.tfvars" -auto-approve
    ```
    Check the result in Azure.
    
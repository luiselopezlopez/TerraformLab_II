# Prerrequisites

1. Copy *backend.tf* from the previous laboratory into the *\terraform* directory.
2. Create **'provider.tf'** file
    ```
    terraform {
        required_providers {
            azurerm = {
                source  = "hashicorp/azurerm"
                version = ">= 3.9.0"
            }

            random = {
                source  = "hashicorp/random"
                version = ">= 3.1.0"
            }
        }
        required_version = ">= 0.15"
    }

    provider "azurerm" {
        features {
            resource_group {
                prevent_deletion_if_contains_resources = false
            }
        }
    }
    ```

[Back to Index](/README.md)
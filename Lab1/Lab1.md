# Configuring a Blob Storage as Backend

## Step 1: Create a resource group
```
az group create --name my-tfstate-rg --location northeurope
```
Replace `my-tfstate-rg` with your preferred resource group name and `northeurope` with your preferred region.

## Step 2: Create a storage account
```
az storage account create --name mytfstatestorageaccount --resource-group my-tfstate-rg --location northeurope --sku Standard_LRS --kind StorageV2
```
Replace `mytfstatestorageaccount` with your preferred storage account name.

## Step 3: Retrieve the primary storage account key

In Linux
```
export AZURE_STORAGE_ACCOUNT=mytfstatestorageaccount
export AZURE_RESOURCE_GROUP=my-tfstate-rg
export AZURE_STORAGE_KEY=$(az storage account keys list --account-name $AZURE_STORAGE_ACCOUNT --resource-group $AZURE_RESOURCE_GROUP --query '[0].value' --output tsv)
```
In Windows (Powershell)
```
$AZURE_STORAGE_ACCOUNT = "mytfstatestorageaccount"
$AZURE_RESOURCE_GROUP = "my-tfstate-rg"
$AZURE_STORAGE_KEY =(az storage account keys list --account-name $AZURE_STORAGE_ACCOUNT --resource-group $AZURE_RESOURCE_GROUP --query [0].value --output tsv)
```
Replace `mytfstatestorageaccount` with your actual storage account name and `my-tfstate-rg` with your actual resource group name.

## Step 4: Create a container for the tfstate file

```
az storage container create --name tfstate --account-name $AZURE_STORAGE_ACCOUNT --account-key $AZURE_STORAGE_KEY
```

Replace `tfstate` with the name of your container.

## Step 5. Create a Storage Backend for Terraform

Next, you need to create a storage backend for Terraform. This will allow you to store the Terraform state file in Blob Storage. To do this, add the following lines to the backend.tf configuration file:

```
terraform {
 backend "azurerm" {
 resource_group_name = "my-tfstate-rg"
 storage_account_name = "mytfstatestorageaccount"
 container_name = "tfstate"
 key = "terraform.tfstate"
 }
}
```

Replace `my-tfstate-rg` with the name of the resource group you want to use for your Terraform state. Replace `mytfstatestorageaccount` with the name of your Blob Storage account.

## Step 6. Initialize the Backend

Now, you need to initialize the backend by running the following command:

```
terraform init
```

This will create a `terraform.tfstate` file in your Blob Storage container.

## Step 7. Use the Storage Backend

You can now use the Blob Storage backend to store your Terraform state. When you run `terraform apply`, Terraform will automatically put the state into the Blob Storage container you have specified.

That's it! You have now setup a Blob Storage backend for storing tfstate in your Terraform configuration.

[Back to Index](/README.md)
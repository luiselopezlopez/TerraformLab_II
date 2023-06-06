
$AZURE_RESOURCE_GROUP = "my-tfstate-rg"
$LOCATION="northeurope"
$AZURE_STORAGE_ACCOUNT = "mytfstatestorageaccount"
az login
az group create --name $AZURE_RESOURCE_GROUP --location $LOCATION
az storage account create --name AZURE_STORAGE_ACCOUNT --resource-group AZURE_RESOURCE_GROUP --location LOCATION --sku Standard_LRS --kind StorageV2
$AZURE_STORAGE_KEY =(az storage account keys list --account-name $AZURE_STORAGE_ACCOUNT --resource-group $AZURE_RESOURCE_GROUP --query [0].value --output tsv)
az storage container create --name tfstate --account-name $AZURE_STORAGE_ACCOUNT --account-key $AZURE_STORAGE_KEY
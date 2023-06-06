# Necessary input variables for Module VNET

variable "resource_group_name" {
    type = string
}
variable "name" {
    type = string
}
variable "location" {
    type = string
}
variable "vnet_address_space" {
    type = list
}
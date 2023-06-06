# Necessary input variables for Module Firewall

variable "resource_group_name" {
    type = string
}
variable "name" {
    type = string
}
variable "spoke_vnet_name" {
    type = string
}
variable "hub_vnet_name" {
    type = string
}

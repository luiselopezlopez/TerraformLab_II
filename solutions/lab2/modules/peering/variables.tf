# Necessary input variables for Module Firewall

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

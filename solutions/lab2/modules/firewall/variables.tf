# Necessary input variables for Module Firewall

variable "resource_group_name" {
    type = string
}
variable "name" {
    type = string
}
variable "location" {
    type = string
}
variable "allowed_fw_ports" {
    type = list
}
variable "fw_subnet_id"{
    type = string
}
variable "fw_public_ip_id" {
    type = string 
}
variable "firewall_policy_id" {
    type = string 
}

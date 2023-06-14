variable "policy_id" {
    type = string
}
variable "ruleCollectionName" {
    type = string
}
variable "rulePriority" {
    type = string
}    
variable "destinationAddress" {
    type = string
}    
variable "destinationPorts" {
    type = list
}    
variable "ruleName" {
    type = string
}    
variable "protocol" {
    type = list
}    
variable "sourceAddress" {
    type = list
}    
variable "translatedAddress" {
    type = string
}    
variable "translatedPort" {
    type = string
}
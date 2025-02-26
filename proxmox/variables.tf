variable "virtual_environment_endpoint" {
  description = "The endpoint for the Proxmox API"
  type        = string
}

variable "virtual_environment_token" {
  description = "API token for Proxmox"
  type        = string
}

variable "virtual_environment_username" {
  description = "Username for SSH access"
  type        = string
}

variable "virtual_environment_password" {
  description = "Password for SSH access"
  type        = string
}

variable "vm_name_prefix" {
  description = "Prefix for VM names."
  type        = string
  default     = "k8s-master"
}



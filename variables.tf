# Define Input Variables
# 1. Azure Location (CentralUS)
# 2. Azure Resource Group Name 
# 3. Azure AKS Environment Name (Dev, QA, Prod)

# Azure Location
variable "location" {
  type        = string
  description = "Azure Region where all these resources will be provisioned"
  default     = "west europe"
}

# Azure Resource Group Name
variable "resource_group_name" {
  type        = string
  description = "This variable defines the Resource Group"
  default     = "terra-malikRG"
}

# Azure AKS Environment Name
variable "env" {
  type        = string
  description = "This variable defines the Environment"
  default     = "dev"
}


# AKS Input Variables

# Linux admin
variable "admin_username" {
  type        = string
  description = "Linux admin"
  default     = "kroo"
}

# SSH Public Key for Linux VMs
variable "ssh_public_key" {
  default     = "./ssh-rsa"
  description = "This variable defines the SSH Public Key for Linux k8s Worker nodes"
}

# Windows Admin Username for k8s worker nodes
variable "windows_admin_username" {
  type        = string
  default     = "kroo"
  description = "This variable defines the Windows admin username k8s Worker nodes"
}

# Windows Admin Password for k8s worker nodes
variable "windows_admin_password" {
  type        = string
  default     = "Security11*2022"
  description = "This variable defines the Windows admin password k8s Worker nodes"
}
variable "petcount" {
  type    = number
  default = 0303
}

variable "Datasource" {
  sensitive = true
  default   = "23d51826-eab0-4218-90ac-caf75c178351"

}

variable "client_secret" {
  sensitive = true
  default   = "5a_8Q~2al5Aisb2ccIU-WiooPmh9tI3qg6nHrbFl"

}
terraform {
  required_providers {
    proxmox = {
      source  = "bpg/proxmox"
      version = "0.70.0" # x-release-please-version
    }
  }
}

provider "proxmox" {
  endpoint  = var.virtual_environment_endpoint
#   api_token = var.virtual_environment_token
  username = var.virtual_environment_username
  password = var.virtual_environment_password
#   username = "root@pam"
#   password = "your-password"
#   private_key = file("~/.ssh/id_ed25519")
  insecure  = true
  ssh {
    agent    = true
#     username = "root@pam"
#     password = "your-password"
    private_key = file("~/.ssh/id_ed25519")
  }
}

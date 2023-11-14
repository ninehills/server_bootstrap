terraform {
  required_providers {
    vultr = {
      source  = "vultr/vultr"
      version = "2.17.1"
    }
  }
}

# Configure the Vultr Provider
provider "vultr" {
  api_key     = var.vultr_api_key
  rate_limit  = 700
  retry_limit = 3
}

resource "vultr_ssh_key" "vultr-dev-ssh-key" {
  name    = "vultr-dev-ssh-key"
  ssh_key = var.ssh_key
}

# Create a dev instance
resource "vultr_instance" "dev" {
  plan                   = "vc2-4c-8gb"
  region                 = "nrt" # Tokyo
  os_id                  = 1743 # Ubuntu 22.04
  hostname               = "vultr-dev"
  enable_ipv6            = true
  backups                = "disabled"
  ssh_key_ids            = [vultr_ssh_key.vultr-dev-ssh-key.id]
  user_data              = "${file("user-data.sh")}"
}
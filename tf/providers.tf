terraform {
  required_version = "> 0.15.0"
  required_providers {
    digitalocean = {
      source = "digitalocean/digitalocean"
      version = "2.8.0"
    }
    local = {
      source = "hashicorp/local"
      version = "2.1.0"
    }
  }
}

provider digitalocean {
  token = var.DO_TOKEN
}

provider local { }

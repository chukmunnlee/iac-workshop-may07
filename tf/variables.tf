variable DO_TOKEN {
  type = string
  sensitive = true
}

variable region {
  type = string
  default = "sgp1"
}

variable volume_size {
  type = number
  default = 1
}

variable droplet_image {
  type = string
  default = "ubuntu-20-04-x64"
}

variable droplet_size {
  type = string
  default = "s-1vcpu-1gb"
}

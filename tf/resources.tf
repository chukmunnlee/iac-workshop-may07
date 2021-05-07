
resource digitalocean_ssh_key mykey {
  name = "mykey"
  public_key = file("../mykey.pub")
}

resource digitalocean_volume myvolume {
  name = "myvolume"
  region = var.region
  size = var.volume_size
  initial_filesystem_type = "ext4"
}

resource digitalocean_droplet mydroplet {
  name = "mydroplet"
  region = var.region
  image = var.droplet_image
  size = var.droplet_size

  ssh_keys = [ digitalocean_ssh_key.mykey.fingerprint ]
  volume_ids = [ digitalocean_volume.myvolume.id ]

  provisioner remote-exec {
    inline = [
      "apt update",
      "apt install nginx -y",
      "systemctl enable nginx",
      "systemctl start nginx",
    ]
    connection {
      type = "ssh"
      user = "root"
      host = self.ipv4_address
      private_key = file("../mykey")
    }
  }
}

resource local_file root_at_ip {
  filename = "root@${digitalocean_droplet.mydroplet.ipv4_address}"
}

output mydrop_ip {
  value = digitalocean_droplet.mydroplet.ipv4_address
}

output mykey_fingerprint {
  value = digitalocean_ssh_key.mykey.fingerprint 
}

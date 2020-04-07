
# separado a una variable y movido al 
# provider "digitalocean" {
#   token = "key_no_vale_hjjrhr5t5jt85t598tu5tu58tu58tu8vgggvgg5ut58ut85ut"
# }

provider "digitalocean" {
  token = var.token
}

#> ssh-keygen -t rsa -b 4096 #para generar claves ssh
resource "digitalocean_ss_key" "default" {
  name       = "example"
  public_key = "${file("id_rsa.pub")}"
}

resource "digitalocean_droplet" "web" {
  image    = "ubuntu-18-04-x64"
  name     = "web-1"
  region   = "nyc3"
  size     = "s-1vcpu-1gb"
  ssh_keys = ["${digitalocean_ss_key.default.fingerprint}"]

  connection {
    user        = "root"
    type        = "ssh"
    host        = "${digitalocean_droplet.web.ip_address}"
    private_key = "${file("~/.ssh/id_rsa")}"
  }

  provisioner "file" {
    source      = "data.sh"
    destination = "/tmp/data.sh"
  }
  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/data.sh",
      "cd /tmp && ./data.sh"
    ]
  }

  #   provisioner "remote-exec" {
  #     inline = [
  #       "apt-get update",
  #       "apt-get install nginx -y"
  #     ]
  #   }
  #   provisioner "file" {
  #     content     = "esto_es_lo_que_comtemdra_vhvhgvhjvhjhhvv"
  #     destination = "/tmp/contenido"
  #   }

  #   provisioner "file" {
  #     content     = "/archivo_a_moverse"
  #     destination = "/tmp/en_esta_carpeta_se_copiara"
  #   }
  #   provisioner "file" {
  #     source      = "data.txt"
  #     destination = "/tmp/data.txt"
  #   }
}


resource "digitalocean_domain" "default" {
  name       = "ubifoos.com"
  ip_address = "${digitalocean_droplet.web.ipv4_address}"
}

resource "digitalocean_record" "subdomain" {
  domain = "${digitalocean_domain.default.name}"
  type   = "A"
  name   = "vpn"
  value  = "${digitalocean_droplet.web.ipv4_address}"
}

# Lo movimos al otro archivo output.tf
# output "ip" {
#   value = "${digitalocean_droplet.web.ipv4_address}"
# }




resource "digitalocean_ssh_key" "rsa" {
 name = "ssh key"
 public_keys = "${file("id_rsa.pub")}" 
}


resource "digitalocean_droplet" "web" {
  image     = "${var.image}"
  name      = "web-1"
  region    = "nyc3"
  size      = "s-1vcpu-1gb"
  user_data = "${file("userdata.yml")}"
    ssh_keys = ["${digitalocean_ssh_key.rsa.fingerprint}"]
}
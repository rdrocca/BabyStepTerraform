provider "digitalocean" {
  token = var.token
}

module "droplet" {
  source = "./modules/droplet"
  imagen = "${var.image}"
}






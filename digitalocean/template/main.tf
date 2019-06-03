# Set the variable value in *.tfvars file
# or using -var="do_token=..." CLI option
variable "do_token" {}
variable "fingerprint" {}


# Configure the DigitalOcean Provider
provider "digitalocean" {
  token = "${var.do_token}"
}

# Create a web server
resource "digitalocean_ssh_key" "default" {
  name       = "DROPLET_NAME_public_key"
  public_key = "${file("./sshkeys/id_rsa.pub")}"
}

resource "digitalocean_droplet" "web" {
  image  = "ubuntu-18-04-x64"
  name   = "DROPLET_NAME"
  region = "DROPLET_REGION"
  size   = "s-1vcpu-1gb"
  tags   = ["terraform", "DROPLET_REGION"]
  ssh_keys = ["${digitalocean_ssh_key.default.fingerprint}"]

  provisioner "file" {
    source      = "./scripts/init_shadowsocks"
    destination = "/tmp/init_shadowsocks"
  }

  provisioner "file" {
    source      = "./scripts/config.json"
    destination = "/tmp/config.json"
  }

  provisioner "remote-exec" {
    inline = [
      "sh /tmp/init_shadowsocks",
      "sed -i \"s,SERVER_IP,${digitalocean_droplet.web.ipv4_address},\" /tmp/config.json",
      "mv /tmp/config.json /etc/shadowsocks-libev/config.json",
      "/etc/init.d/shadowsocks-libev start",
      "systemctl start shadowsocks-libev",
      "systemctl enable shadowsocks-libev",
      "sleep 5",
      "systemctl restart shadowsocks-libev",
    ]
  }

  provisioner "local-exec" {
    command = <<EOF
      echo "\n" \
      "Host DROPLET_NAME\n" \
      "  HostName ${digitalocean_droplet.web.ipv4_address}\n" \
      "  Port 22\n" \
      "  User root\n" \
      "  IdentityFile ~/.ssh/id_rsa\n" >> ~/.ssh/config
    EOF
  }
}

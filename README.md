# How to use

## Pre-requirement

> terraform

https://www.terraform.io/downloads.html

> ssh

Generate an ssh key is important.

https://help.github.com/en/articles/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent

Please generate an sshkey using the above link as an guide. Copy the *.pub file to ./template/sshkeys, and rename it to `id_rsa.pub`

> Firewall


## Config
In file `run`, edit values below according to your condition

```bash
# Generate token here https://cloud.digitalocean.com/account/api/tokens
DO_TOKEN=""
# [nyc1, nyc3, sfo2, ams3, sgp1, lon1, fra1, tor1, blr1]
DROPLET_REGION=""
# select your port where server provide shadowsocks service
SERVER_PORT=
# set your own shadowsocks password
PASSWORD=""
# set finger print if has ssh key set
FINGERPRINT=""
```
## Public keys
copy your ssh public key to path `sshkeys`, and rename it `id_rsa.pub`

## Run

```bash
cd digitalocean
./run {server-name-you-give}
```

# Reminder

If you ever created a firewall role in digitalocean, please add the instance you created to the role.
And ssh to the instance, to run

```bash
systemctl restart shadowsocks-libev
lsof -i:{SERVER_PORT}
```

# LICENCE

DO NOT USE FOR ILLEGAL PURPOSE ACCORDING TO LAWS OF PRC.

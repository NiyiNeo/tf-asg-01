#!/bin/bash
set -euxo pipefail
export DEBIAN_FRONTEND=noninteractive

# Update packages and install Apache
apt-get update -y
apt-get install -y apache2

#Start now and on boot
systemctl enable --now apache2

# Create a simple landing page
HOSTNAME_FQDN="$(hostname -f || hostname)"
INSTANCE_ID="$(curl -s http://169.254.169.254/latest/meta-data/instance-id || echo unknown)"

cat >/var/www/html/index.html <<EOF
<!DOCTYPE html>
<html>
  <head>
    <meta charset="utf-8" />
    <title>Apache on Ubuntu (ASG)</title>
  </head>
  <body>
    <h1>Hello from ${HOSTNAME_FQDN}</h1>
    <p>Instance ID: ${INSTANCE_ID}</p>

    <hr/>

    <h2>Season Greetings!</h2>
    <p>Nothing beats a Sale from Holiday Haven!</p>
  </body>
</html>
EOF

# Permissions 
chown www-data:www-data /var/www/html/index.html || true
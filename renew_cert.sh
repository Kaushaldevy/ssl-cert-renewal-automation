#!/bin/bash

DOMAIN="<your_domain>" # Replace this with your domain. eg: techbyk.com
EMAIL="<your_email>" # Replace this with your email
HOSTED_ZONE_ID="<route53_hosted_zone>" # Replace this with your hosted zone ID. Can get from aws route53 list-hosted-zones

# Step 1: Request certificate via DNS challenge
certbot certonly --manual --preferred-challenges=dns --email "$EMAIL" --server https://acme-v02.api.letsencrypt.org/directory -d "$DOMAIN" -d "*.$DOMAIN" --agree-tos --manual-public-ip-logging-ok --manual-auth-hook /etc/certbot/authenticator.sh --non-interactive

sleep 2;

# View the updated SSL cert expiry
openssl x509 -in /home/ec2-user/apache-proxy/fullchain.pem -text -noout |grep -i -B1 -A3 validity

# Step 2: Restart Apache to apply the new certificate
systemctl restart httpd

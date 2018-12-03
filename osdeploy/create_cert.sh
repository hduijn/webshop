#!/bin/bash
#
# create or renew SSL certificate
#
# author: hugo.vanduijn@naturalis.nl
#

cd /opt/letsencryptssl
certbot --server https://acme-v02.api.letsencrypt.org/directory certonly \
  --manual --email hugo@vanduijnict.nl --manual-public-ip-logging-ok --agree-tos --non-interactive \
  --preferred-challenges dns \
  --expand --renew-by-default \
  --config-dir /etc/letsencrypt \
  --logs-dir /var/log/letsencrypt \
  --work-dir ./ \
  --manual-auth-hook ./auth-hook --manual-cleanup-hook ./cleanup-hook \
  -d test.repairwebshop.nl

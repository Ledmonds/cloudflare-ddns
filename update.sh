#!/bin/sh
result=$(curl --silent --request GET \
  --url https://api.cloudflare.com/client/v4/zones/${ZONE_ID}/dns_records/${DNS_RECORD_ID} \
  --header 'Content-Type: application/json' \
  --header 'X-Auth-Email: '${CLOUDFLARE_EMAIL}'' \
  --header 'X-Auth-Key: '${API_KEY}'')

# Cut in Alpine doesn't support fully qualified argument names
IP=$(echo $result | jq .result.content | cut -d '"' -f 2)

QUERIED_IP=$(curl --silent https://api.ipify.org)

if [ "$IP" != "$QUERIED_IP" ]; then
  curl --silent --request PATCH \
    --url https://api.cloudflare.com/client/v4/zones/${ZONE_ID}/dns_records/${DNS_RECORD_ID} \
    --header 'Content-Type: application/json' \
    --header 'X-Auth-Email: '${CLOUDFLARE_EMAIL}'' \
    --header 'X-Auth-Key: '${API_KEY}'' \
    --data '{
    "content": "'${QUERIED_IP}'",
    "name": "'${FULLY_QUALIFIED_DOMAIN_NAME}'",
    "proxied": false,
    "type": "A",
    "comment": "",
    "tags": [],
    "ttl": 3600
  }'

  echo 'IP is out-of-date; updating!'
  
  IP=$QUERIED_IP
else
  echo "IP is still current; not-updating!"
fi

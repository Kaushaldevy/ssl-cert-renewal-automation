#!/bin/bash

# Values set dynamically by certbot
DOMAIN="_acme-challenge.techbyk.com" # Update this based on your site. For this site techbyk.com, the above is the domain.
VALUE="$CERTBOT_VALIDATION" # Here, this is an environment variable that has the validation string. (source: https://eff-certbot.readthedocs.io/en/stable/using.html#pre-and-post-validation-hooks)
TTL=60
HOSTED_ZONE_ID="<hosted_zone_id>"  # The correct hosted zone ID

# Log information for debugging
echo "Updating DNS record for $DOMAIN with validation value $VALUE in hosted zone $HOSTED_ZONE_ID"

# Step to update the DNS TXT record in Route 53
aws route53 change-resource-record-sets --hosted-zone-id "$HOSTED_ZONE_ID" --change-batch "{
  \"Changes\": [{
    \"Action\": \"UPSERT\",
    \"ResourceRecordSet\": {
      \"Name\": \"$DOMAIN\",
      \"Type\": \"TXT\",
      \"TTL\": $TTL,
      \"ResourceRecords\": [{\"Value\": \"\\\"$VALUE\\\"\"}]
    }
  }]
}"

echo "Waiting for DNS propagation..."
sleep 120  # Optional, adjust sleep based on DNS propagation time

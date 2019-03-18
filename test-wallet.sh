#!/usr/bin/env bash

VERSION="v1.26.2"
BASEURI="http://wallet.local/api/{$VERSION}/"
DOMAIN_ID="15"
# Get this from running scripts/console dev:import-transaction in QWA
TRANSACTION_ID=3805349769
USER_ID=8335989

# Add a bank account
curl -X PUT -vvv \
    --header "Content-Type: application/json" \
    --header "Accept: application/json" \
    --header "Access-Token: $(echo $DOMAIN_ID)" \
    -d "{\"sort_code\": 307431, \"account_number\": 83949021, \"holder_name\": \"FD Oosterbroek\", \"change_source\": \"Admin\", \"admin_user_id\": 0, \"source_ip\": \"127.0.0.1\"}" \
    "$(echo ${BASEURI})wallet/user/$(echo ${USER_ID})/payment-account/bacs?bypass_validation=true"

# Get payment-accounts
curl -X GET -vvv \
    --header "Access-Token: $(echo ${DOMAIN_ID})" \
    --header "Accept: application/json" \
    "$(echo ${BASEURI})wallet/user/8335989/payment-accounts"

# Account off hold
curl -X PATCH -vvv \
    --header "Content-Type: application/json" \
    --header "Accept: application/json" \
    --header "Access-Token: $(echo ${DOMAIN_ID})" \
    "$(echo ${BASEURI})wallet/user/$(echo ${USER_ID})/remove-payment-lock?payment_type=bacs"

# Add a transaction
curl -X POST -vvv \
    --header "Access-Token: $(echo ${DOMAIN_ID})" \
    --header "Content-Type: application/json" \
    --header "Accept: application/json" \
    -d "{
      \"wallet_transactions\": [
        {
          \"user_id\": $(echo ${USER_ID}),
          \"amount\": 1.05,
          \"reference_identifier\": \"$(echo ${TRANSACTION_ID})\",
          \"description\": \"Test 01\",
          \"is_proprietary\": false
        }
      ]
    }" \
    "$(echo ${BASEURI})wallet/credit/transactions"

# Create a payment request
curl -X POST -vvv \
  --header 'Accept: application/json' \
  --header "Access-Token: $(echo ${DOMAIN_ID})" \
  --header 'Cache-Control: no-cache' \
  --header 'Content-Type: application/x-www-form-urlencoded' \
  -d amount=1.05 \
  -d user_id=$(echo ${USER_ID}) \
  $(echo ${BASEURI})wallet/user/$(echo ${USER_ID})/payment-request/bacs

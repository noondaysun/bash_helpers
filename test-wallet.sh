#!/usr/bin/env bash

VERSION="v1.26.2"
BASEURI="http://wallet.local/api/{$VERSION}/"
DOMAIN_ID="15"
# Get this from running scripts/console dev:import-transaction in QWA
TRANSACTION_ID=3805349821
USER_ID=8339347

# Add a bank account
curl -X PUT -vvv \
    --header "Content-Type: application/json" \
    --header "Accept: application/json" \
    --header "Access-Token: ${DOMAIN_ID}" \
    -d "{\"sort_code\": \"307431\", \"account_number\": \"83949021\", \"holder_name\": \"FD Oosterbroek\", \"user_email\": \"f.oosterbroek+yawIV@quidco.com\", \"change_source\": \"Admin\", \"admin_user_id\": 0, \"source_ip\": \"127.0.0.1\"}" \
    "${BASEURI}wallet/user/${USER_ID}/payment-account/bacs?bypass_validation=true"

sleep 2

# Get payment-accounts
curl -X GET -vvv \
    --header "Access-Token: ${DOMAIN_ID}" \
    --header "Accept: application/json" \
    ${BASEURI}wallet/user/${USER_ID}/payment-accounts

sleep 2

# Account off hold
curl -X PATCH -vvv \
    --header "Content-Type: application/json" \
    --header "Accept: application/json" \
    --header "Access-Token: ${DOMAIN_ID}" \
    "${BASEURI}wallet/user/${USER_ID}/remove-payment-lock?payment_type=bacs"

sleep 2

# Add a transaction
curl -X POST -vvv \
    --header "Access-Token: ${DOMAIN_ID}" \
    --header "Content-Type: application/json" \
    --header "Accept: application/json" \
    -d "{
      \"wallet_transactions\": [
        {
          \"user_id\": ${USER_ID},
          \"amount\": 1.05,
          \"reference_identifier\": \"${TRANSACTION_ID}\",
          \"description\": \"Test 01\",
          \"is_proprietary\": false
        }
      ]
    }" \
    ${BASEURI}wallet/credit/transactions

sleep 2

# Create a payment request
curl -X POST -vvv \
  --header 'Accept: application/json' \
  --header "Access-Token: ${DOMAIN_ID}" \
  --header 'Cache-Control: no-cache' \
  --header 'Content-Type: application/x-www-form-urlencoded' \
  -d amount=1.05 \
  -d user_id=${USER_ID} \
  ${BASEURI}wallet/user/${USER_ID}/payment-request/bacs

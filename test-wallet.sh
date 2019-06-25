#!/usr/bin/env bash

cd ~/Git/wallet || exit
echo "On branch: $(git rev-parse --abbrev-ref HEAD)"

if [[ -z "${VERSION}" ]]; then
    VERSION="v1"
fi
if [[ -z "${DOMAIN_ID}" ]]; then
    DOMAIN_ID=1
fi
if [[ -z "${USER_ID}" ]]; then
    USER_ID=78
fi
# Get this from running scripts/console dev:import-transaction in QWA
if [[ -z "${TRANSACTION_ID}" ]]; then
    TRANSACTION_ID=$((RANDOM%4000000+3000000))
fi

echo "Using version ${VERSION}, and domain ${DOMAIN_ID} for user_id ${USER_ID} and transaction_id ${TRANSACTION_ID}"

if [[ -z "${BASEURI}" ]]; then
    BASEURI="http://wallet.local.syrupme.net/api/{$VERSION}/"
fi

PAYMENT_TYPE_EXISTS=$(curl -X GET -vvv \
    --header "Content-Type: application/json" \
    --header "Accept: application/json" \
    --header "Access-Token: ${DOMAIN_ID}" \
    "${BASEURI}wallet/payment-types" | jq ".payment_types[].name" | grep -i "bacs")

if [[ -z "${PAYMENT_TYPE_EXISTS}" ]]; then
    curl -X POST \
        --header "Content-Type: application/json" \
        --header "Accept: application/json" \
        --header "Access-Token: ${DOMAIN_ID}" \
        -d "{
            \"name\": \"BACS\",
            \"minimum\": 1,
            \"maximum\": 5000,
            \"endpoint\": \"bacs\",
            \"payment_fee\": 0.50,
            \"provider\": \"winbacs\",
            \"active\": true,
            \"terms_and_conditions\": {
                \"content\": \"These are some terms, and conditions.<br />1. Gondolas' are frowned upon.<br />2.Must walk in such a way as to invite entrance into the Ministry of Funny Walks.\"
            },
            \"start_at\": \"2019-04-12T07:50:45.060Z\",
            \"end_at\": \"2020-04-12T07:50:45.060Z\"
        }" \
        "${BASEURI}wallet/payment-types"

        sleep 2
fi

# Add a bank account
curl -X PUT -vvv \
    --header "Content-Type: application/json" \
    --header "Accept: application/json" \
    --header "Access-Token: ${DOMAIN_ID}" \
    -d "{
        \"sort_code\": \"307431\",
        \"account_number\": \"83949021\",
        \"holder_name\": \"FD Oosterbroek\",
        \"user_email\": \"f.oosterbroek+yawIV@quidco.com\",
        \"change_source\": \"Admin\",
        \"admin_user_id\": 0,
        \"source_ip\": \"127.0.0.1\"
    }" \
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

# Check user balance
sleep 2
curl -X GET -vvv \
    --header "Access-Token: ${DOMAIN_ID}" \
    --header "Accept: application/json" \
    ${BASEURI}wallet/user/${USER_ID}/balance

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

sleep 2
# Generate payments
curl -X POST \
    --header "Content-Type: application/json" \
    --header "Accept: application/json" \
    --header "Access-Token: ${DOMAIN_ID}" \
    "${BASEURI}wallet/payment/generate-payments/bacs"

sleep 2
# regenerate the payment file
curl -X PUT \
    --header "Content-Type: application/json" \
    --header "Accept: application/json" \
    --header "Access-Token: ${DOMAIN_ID}" \
    "${BASEURI}wallet/payment/regenerate/bacs"

sleep 2
# Get payment file
curl -X GET \
    --header "Accept: application/octet-stream" \
    --header "Access-Token: ${DOMAIN_ID}" \
    "${BASEURI}wallet/payments/files/payments_out_winbacs_youatwork.csv"

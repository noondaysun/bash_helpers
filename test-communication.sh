#!/usr/bin/env bash

cd ~/Git/communication || exit
echo "On branch: $(git rev-parse --abbrev-ref HEAD)"

if [[ -z "${VERSION}" ]]; then
    VERSION="v2"
fi
if [[ -z "${USER_ID}" ]]; then
    USER_ID=78
fi
if [[ -z "${DOMAIN_ID}" ]]; then
    DOMAIN_ID=1
fi
if [[ -z "${BASEURI}" ]]; then
    BASEURI="http://communication.local.syrupme.net/api/{$VERSION}/"
fi


curl --request POST \
  --url "${BASEURI}"communication/event \
  --header 'accept: application/json' \
  --header "access-token: ${DOMAIN_ID}" \
  --header 'cache-control: no-cache' \
  --header 'content-type: application/json' \
  --data "{
    \"event\":\"PurchaseTrackingConfirmation\",
    \"dispatchers\": [\"email\"],
    \"recipient\": {
        \"user_id\":\"${USER_ID}\",
        \"email\":\"f.oosterbroek+test@quidco.com\"
    },
    \"content\": {
        \"email\": {
            \"merchant\": {
                \"id\":\"123\",
                \"name\":\"First TransPennine Express Test\",
                \"url_name\":\"first-transpennine-express\",
                \"slug\":\"first-transpennine-express\",
                \"transaction\":{
                    \"amount\":\"49.60\",
                    \"cashback\":\"12.05\",
                    \"date\":\"2018-11-12T09:40:36+0000\",
                    \"frontend_status\":\"confirmed\",
                    \"transaction_id\": \"12345678\"
                }
            }
        }
    }
}"

# Confirm that a new event has been added to rabbitmq
docker exec rabbitmq bash -c \
    "rabbitmqadmin -u${RABBIT_USER} -p${RABBIT_PASS} get queue=qplatform.events.communication.triggered.transactional count=10"

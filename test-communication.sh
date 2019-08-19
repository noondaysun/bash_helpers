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

curl -X POST \
  "${BASEURI}"communication/user/${USER_ID}/preferences/ \
  -H "Access-Token: ${DOMAIN_ID}" \
  -H 'Content-Type: application/json' \
  -H 'cache-control: no-cache' \
  -H 'clientId: www' \
  -d '{
"preferences": {
        "email": {
            "chances_to_win": false,
            "offers": false,
            "surveys": false
        }
    }    
}'

if [[ -n "$(docker ps | grep -i rabbitmq)" ]]; then
    docker exec rabbitmq bash -c "rabbitmqctl list_queues"
fi
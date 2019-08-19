#!/usr/bin/env bash

# Ensure that we include .bash_profile
if [[ -f ~/.bash_profile ]]; then
    source ~/.bash_profile
fi

if [[ -z "${BASE_URI}" ]]; then
    BASE_URI=http://middlelayer.local.syrupme.net
fi

# bring up middlelayer environment
cd ~/Git/middlelayer || exit
echo "On branch: $(git rev-parse --abbrev-ref HEAD)"
# todo fix the below (nvm issue (not found), check to see if container already running)
nvm use --delete-prefix
npm cache verify
#npm i
#npm run-script test
#docker-compose up -d
sleep 20

if [[ -n "${MANUAL_TEST}" ]]; then
    if [[ -z "${SITE_TOKEN}" ]]; then
        echo "Usage: MANUAL_TEST=1 SITE_TOKEN=**** ${0}"
        exit 1
    fi

    if [[ -z "${MERCHANT_ID}" ]]; then
        MERCHANT_ID=3
    fi

    curl -X GET -vvv \
    --header "qp-site-token: ${SITE_TOKEN}" \
    "${BASE_URI}/api/pages/merchants/"

    curl -X GET -vvv \
    --header "qp-site-token: ${SITE_TOKEN}" \
    "${BASE_URI}/api/programs/3456/redirect?merchant_id=20410&fn=toolbar"
fi

# Run m-api-health-check
cd ~/Git/m-api-health-check/ || exit
echo "On branch: $(git rev-parse --abbrev-ref HEAD)"

echo "Running: nvm use v8.9.4 && npm test -- --target=${BASE_URI} --domainId=${DOMAIN_ID} --environment=local --verbose"
if [[ -n "${DOMAIN_ID}" ]]; then
    nvm use --delete-prefix v8.9.4 && npm test -- --target="${BASE_URI}" --domainId="${DOMAIN_ID}" --environment=local --verbose
else
    # loop through all domains
    # todo ensure domains are not static array
    domains=(1 11 12 14 15 20 31 33 34 35 36 200 201 202);
    for i in "${domains[@]}"; do
        echo "Testing domain: ${i}"
        nvm use --delete-prefix v8.9.4 && npm test -- --target="${BASE_URI}" --domainId="${i}" --environment=local --verbose
    done
fi

# Once testing complete remove environment
cd ~/Git/middlelayer || exit
# todo debug for logs, confirm down
#docker-compose logs -t
#docker-compose down
#!/usr/bin/env bash

# Ensure that we include .bash_profile
if [ -f ~/.bash_profile ]; then
    source ~/.bash_profile
fi

BASE_URI=http://middlelayer.local.syrupme.net

# bring up middlelayer environment
cd ~/Git/middlelayer || exit
nvm use
npm cache verify
npm i
npm run-script test
docker-compose up -d
sleep 20

cd ~/Git/m-api-health-check/ || exit

echo "Running: nvm use v8.9.4 && npm test -- --target=${BASE_URI}"
nvm use v8.9.4 && npm test -- --target=${BASE_URI}

# Once testing complete remove environment
cd ~/Git/middlelayer || exit
docker-compose logs -t
docker-compose down
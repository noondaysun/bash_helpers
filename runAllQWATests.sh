#! /bin/bash

set -e

# Ensure we are using the correct $JAVA_HOME
export JAVA_HOME=$(/usr/libexec/java_home -v 1.8)
java_version=$(javac -version)
site_url=${site_url:-https://quidco.local.syrupme.net}

if [[ ${java_version} =~ "!1\.8.*" ]]; then
    echo "Required java version is 1.8.*. Please install version 1.8, and retry."
    exit 0
fi

cd ~/Git/maplequidco || exit

for i in ./src/test/java/com/quidco/app/cucumber/*; do
    file=$(basename "${i}")
    handle=${file%%.java}
    if [[ "${handle}" =~ "Runner" ]]; then
        mvn clean test -Dtest="${handle}" -Denv="${site_url}" -Dheadless -Dcucumber.options="--no-monochrome"
    fi
done

cd ~/Git/quidco-frontend-tests || exit

for i in ./src/test/java/runners/*; do
    file=$(basename "${i}")
    handle=${file%%.java}
    if [[ "${handle}" =~ "Runner" ]]; then
        mvn clean verify -Dtest="${handle}" -Denv="${site_url}" -Dcredentials=TestCredentials -Dtimeout=30 -Dsize=1024x768
    fi
done

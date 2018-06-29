#! /bin/bash
 
VERSION=$1
echo "Purging old release"
if [ -f /usr/bin/docker-compose ]; then
    rm /usr/bin/docker-compose
fi
if [ -f /usr/local/bin/docker-compose ]; then
    /usr/local/bin/docker-compose
fi
echo "Installing new version ${VERSION}"
curl -L https://github.com/docker/compose/releases/download/${VERSION}/docker-compose-`uname -s`-`uname -m` -o /usr/local/bin/docker-compose
echo "Symlinking to /usr/bin"
ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose
echo "Setting executable status"
chmod 0755 /usr/local/bin/docker-compose
chmod 0755 /usr/bin/docker-compose

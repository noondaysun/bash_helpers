#!/usr/bin/env bash

sudo update-alternatives --set php /usr/bin/php"${1}"
sudo update-alternatives --set phar /usr/bin/phar"${1}"
sudo update-alternatives --set phar.phar /usr/bin/phar.phar"${1}"
sudo update-alternatives --set phpize /usr/bin/phpize"${1}"
sudo update-alternatives --set php-config /usr/bin/php-config"${1}"

sudo /etc/init.d/php"${1}"-fpm restart
sudo /etc/init.d/nginx restart
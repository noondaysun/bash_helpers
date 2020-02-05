## BASH

** Random **

To get a random number Mac|FreeBSD run the below:
```shell
jot -r 1 9000000000 9999999999
```
To get a randomish number in bash
```shell
random=$((RANDOM%4000000+3000000)); echo "${random}"
```
To get a random alpha-numeric string
```shell
cat /dev/urandom | env LC_CTYPE=C tr -dc 'a-zA-Z0-9' | fold -w 16 | head -n 1
```

** Faketime **
```
# Install perl and tools for make to work correctly
# for Alpine this should be
apk add perl build-base

git clone https://github.com/wolfcw/libfaketime /libfaketime; \
cd /libfaketime || exit && \
make && make install

# To use
export LD_PRELOAD=/usr/local/lib/faketime/libfaketimeMT.so.1
FAKETIME='-100d' date +%Y-%m-%d
```
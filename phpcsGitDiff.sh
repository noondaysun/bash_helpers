#!/bin/bash

if [ -z ${1+x} ]; then 
	echo "Usage: $0 aValidBranchName"
	exit 1
fi

BRANCH=$1

FILES=$(git diff --name-only HEAD ${BRANCH});

if [ ! -z "$FILES" ]; then
    phpcs --standard=PSR2 $FILES
fi
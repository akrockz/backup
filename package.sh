#!/bin/bash

set -e

echo "backup package script running."

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )" # this script's directory
STAGING="${DIR}/../_staging"
echo "STAGING=${STAGING}"

# Setup, cleanup.
cd $DIR
mkdir -p $STAGING # files dir for lambdas
rm -rf $STAGING/*

# Copy deployspec and CFN templates into staging folder.
cp -pr $DIR/../*.yaml $STAGING/

# Package code folders into zip files.
cd $DIR/../scripts/
zip --symlinks -r9 $STAGING/scripts.zip *

echo "backup package step complete, run.sh can be executed now."

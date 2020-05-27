#!/bin/bash -e
#
# Copyright (c) 2020 Snowflake Computing Inc. All right reserved.
#
#

function usage()
{
    echo "usage: ./build_and_publish_rpm.sh [TARGET_YUM_REPO] [TARGET_HOST_URL]"
    exit 1
}

if [ "$#" -ne 2 ]; then
  usage
fi


THIS_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source $THIS_DIR/version.sh
TARGET_YUM_REPO=$1
TARGET_HOST_URL=$2

if [[ -z $TARGET_YUM_REPO ]]; then
  echo "ERROR: {TARGET_YUM_REPO} not specified"
  exit 1
fi

if [[ -z $TARGET_HOST_URL ]]; then
  echo "ERROR: {TARGET_HOST_URL} not specified"
  exit 1
fi

$THIS_DIR/../platform/rpm/mkrpm.sh firejail $FIREJAIL_SF_VERSION \
    "--disable-userns --disable-contrib-install --disable-file-transfer --disable-x11 --disable-firetunnel"

PACKAGE_NAME=$(ls -1 -- firejail-${FIREJAIL_SF_VERSION}-1.x86_64.rpm)

if [[ -z $PACKAGE_NAME ]]; then
  echo "ERROR: RPM package not found"
  exit 1
fi

$THIS_DIR/publish_rpm.sh $TARGET_YUM_REPO $TARGET_HOST_URL $PACKAGE_NAME

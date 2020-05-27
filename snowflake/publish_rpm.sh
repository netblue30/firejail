#!/bin/bash -ex
#
# Copyright (c) 2020 Snowflake Computing Inc. All right reserved.
#
#
TARGET_REPO=$1
REPO_HOST=$2
SSH_OPT="-o UserKnownHostsFile=/dev/null -o PasswordAuthentication=no -o StrictHostKeyChecking=no"

if [ ! -z "$3" ]; then
  RPMS=($3)
else
  # list current directory to get rpm
  RPMS=$(ls -1 -- *.rpm)
fi

scp $OPT $RPMS jenkins@$REPO_HOST:/tmp
for each in $RPMS; do
  ssh -l jenkins $SSH_OPT $REPO_HOST \
    "sudo -u yumrepo /opt/sfc/operations/scripts/yum_repos/add_rpm_to_repository.pl $TARGET_REPO /tmp/$each"
  ssh $SSH_OPT jenkins@$REPO_HOST rm -f /tmp/$each
done

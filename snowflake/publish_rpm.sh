#!/bin/bash -ex
#
# Copyright (c) 2020 Snowflake Computing Inc. All right reserved.
#
#
TARGET_REPO=$1
SSH_OPT="-o UserKnownHostsFile=/dev/null -o PasswordAuthentication=no -o StrictHostKeyChecking=no"
REPO_HOST=repo-ha-write.int.snowflakecomputing.com

if [ ! -z "$2" ]; then
  RPMS=($2)
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

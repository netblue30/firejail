# This file is overwritten during software install.
# Persistent customizations should go in a .local file.
include allow-ssh.local

noblacklist ${HOME}/.ssh
noblacklist /etc/ssh
noblacklist /etc/ssh/ssh_config
noblacklist /tmp/ssh-*
noblacklist ${PATH}/ssh
noblacklist /usr/lib/openssh/ssh-keysign

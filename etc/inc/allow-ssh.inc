# This file is overwritten during software install.
# Persistent customizations should go in a .local file.
include allow-ssh.local

nodeny  ${HOME}/.ssh
nodeny  /etc/ssh
nodeny  /etc/ssh/ssh_config
nodeny  /tmp/ssh-*

# This file is overwritten during software install.
# Persistent customizations should go in a .local file.
include allow-ssh.local

noblacklist ${HOME}/.ssh
noblacklist /etc/ssh
noblacklist /etc/ssh/ssh_config
noblacklist /etc/ssh/ssh_config.d
noblacklist ${PATH}/ssh*
noblacklist /tmp/ssh-*
# Arch Linux and derivatives
noblacklist /usr/lib/ssh
# Debian/Ubuntu and derivatives
noblacklist /usr/lib/openssh
# Fedora and derivatives
noblacklist /usr/libexec/openssh

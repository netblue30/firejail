# This file is overwritten during software install.
# Persistent customizations should go in a .local file.
include disable-exec.local

noexec ${HOME}
noexec ${RUNUSER}
noexec /dev/shm
noexec /tmp
# /var/tmp is noexec by default
# just in case there is a keep-var-tmp option:
noexec /var/tmp

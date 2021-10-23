# This file is overwritten during software install.
# Persistent customizations should go in a .local file.
include disable-exec.local

noexec ${HOME}
noexec ${RUNUSER}
noexec /dev/mqueue
noexec /dev/shm
noexec /run/shm
noexec /tmp
# /var is noexec by default for unprivileged users
# except there is a writable-var option, so just in case:
noexec /var

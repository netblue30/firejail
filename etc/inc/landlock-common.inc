# This file is overwritten during software install.
# Persistent customizations should go in a .local file.
include landlock-common.local

landlock.fs.read /          # whole system read
landlock.fs.read /proc
landlock.fs.makeipc /       # sockets etc.

# write access
landlock.fs.write ${HOME}
landlock.fs.write ${RUNUSER}
landlock.fs.write /dev
landlock.fs.write /proc
landlock.fs.write /run/shm
landlock.fs.write /tmp

# exec access
## misc
landlock.fs.execute ${PATH}
landlock.fs.execute /opt
landlock.fs.execute /run/firejail # appimage and various firejail features
## lib
landlock.fs.execute /lib
landlock.fs.execute /lib32
landlock.fs.execute /libx32
landlock.fs.execute /lib64
landlock.fs.execute /usr/lib
landlock.fs.execute /usr/lib32
landlock.fs.execute /usr/libx32
landlock.fs.execute /usr/lib64
landlock.fs.execute /usr/local/lib

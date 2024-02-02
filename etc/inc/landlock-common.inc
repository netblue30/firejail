# This file is overwritten during software install.
# Persistent customizations should go in a .local file.
include landlock-common.local

landlock.read /          # whole system read
landlock.read /proc
landlock.makeipc /       # sockets etc.

# write access
landlock.write ${HOME}
landlock.write ${RUNUSER}
landlock.write /dev
landlock.write /proc
landlock.write /run/shm
landlock.write /tmp

# exec access
## misc
landlock.execute /opt
landlock.execute /run/firejail # appimage and various firejail features
## bin
landlock.execute /bin
landlock.execute /sbin
landlock.execute /usr/bin
landlock.execute /usr/sbin
landlock.execute /usr/games
landlock.execute /usr/local/bin
landlock.execute /usr/local/sbin
landlock.execute /usr/local/games
## lib
landlock.execute /lib
landlock.execute /lib32
landlock.execute /libx32
landlock.execute /lib64
landlock.execute /usr/lib
landlock.execute /usr/lib32
landlock.execute /usr/libx32
landlock.execute /usr/lib64
landlock.execute /usr/local/lib

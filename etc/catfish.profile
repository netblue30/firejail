# Persistent global definitions go here
include /etc/firejail/globals.local

# This file is overwritten during software install.
# Persistent customizations should go in a .local file.
include /etc/firejail/catfish.local

# Firejail profile for catfish
noblacklist ~/.config/catfish

# We can't blacklist much since catfish
# is for finding files/content
include /etc/firejail/disable-devel.inc

caps.drop all
no3d
nogroups
nonewprivs
noroot
nosound
novideo
protocol unix
seccomp
shell none
tracelog

# These options work but are disabled in case
# a users wants to search in these directories.
#private-bin bash,catfish,env,locate,ls,mlocate,python,python2,python2.7,python3,python3.5,python3.5m,python3m
#private-dev
#private-tmp

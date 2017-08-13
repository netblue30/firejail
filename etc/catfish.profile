# Firejail profile for catfish
# This file is overwritten after every install/update
# Persistent local customizations
include /etc/firejail/catfish.local
# Persistent global definitions
include /etc/firejail/globals.local

# We can't blacklist much since catfish
# is for finding files/content
noblacklist ~/.config/catfish

include /etc/firejail/disable-devel.inc

caps.drop all
net none
no3d
nodvd
nogroups
nonewprivs
noroot
nosound
notv
novideo
protocol unix
seccomp
shell none
tracelog

# These options work but are disabled in case
# a users wants to search in these directories.
# private-bin bash,catfish,env,locate,ls,mlocate,python,python2,python2.7,python3,python3.5,python3.5m,python3m
# private-dev
# private-tmp

# Firejail profile for catfish
# Description: File searching tool
# This file is overwritten after every install/update
# Persistent local customizations
include /etc/firejail/catfish.local
# Persistent global definitions
include /etc/firejail/globals.local

# We can't blacklist much since catfish
# is for finding files/content

noblacklist ${HOME}/.config/catfish

# Allow python (blacklisted by disable-interpreters.inc)
noblacklist ${PATH}/python2*
noblacklist ${PATH}/python3*
noblacklist /usr/lib/python2*
noblacklist /usr/lib/python3*

include /etc/firejail/disable-common.inc
# include /etc/firejail/disable-devel.inc
include /etc/firejail/disable-interpreters.inc
include /etc/firejail/disable-passwdmgr.inc
include /etc/firejail/disable-programs.inc

whitelist /var/lib/mlocate
include /etc/firejail/whitelist-var-common.inc

caps.drop all
net none
no3d
nodbus
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
# private-bin bash,catfish,env,locate,ls,mlocate,python*
# private-dev
# private-tmp

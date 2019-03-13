# Firejail profile for catfish
# Description: File searching tool
# This file is overwritten after every install/update
# Persistent local customizations
include catfish.local
# Persistent global definitions
include globals.local

# We can't blacklist much since catfish
# is for finding files/content

noblacklist ${HOME}/.config/catfish

# Allow python (blacklisted by disable-interpreters.inc)
noblacklist ${PATH}/python2*
noblacklist ${PATH}/python3*
noblacklist /usr/lib/python2*
noblacklist /usr/lib/python3*
noblacklist /usr/local/lib/python2*
noblacklist /usr/local/lib/python3*

include disable-common.inc
# include disable-devel.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc

whitelist /var/lib/mlocate
include whitelist-var-common.inc

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

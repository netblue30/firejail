# Firejail profile for ranger
# Description: File manager with an ncurses frontend written in Python
# This file is overwritten after every install/update
# Persistent local customizations
include ranger.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.config/nano
noblacklist ${HOME}/.config/ranger
noblacklist ${HOME}/.nanorc

# Allow python (blacklisted by disable-interpreters.inc)
include allow-python2.inc
include allow-python3.inc

# Allow perl
include allow-perl.inc

include disable-common.inc
include disable-devel.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc

caps.drop all
net none
nodbus
nodvd
nogroups
nonewprivs
noroot
nosound
notv
nou2f
novideo
protocol unix
seccomp
#x11 none

private-dev

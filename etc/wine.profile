# Firejail profile for wine
# Description: A compatibility layer for running Windows programs
# This file is overwritten after every install/update
# Persistent local customizations
include wine.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.Steam
noblacklist ${HOME}/.local/share/Steam
noblacklist ${HOME}/.local/share/steam
noblacklist ${HOME}/.steam
noblacklist ${HOME}/.wine

include disable-common.inc
include disable-devel.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc

# uncomment next line if seccomp breaks a program
# allow-debuggers
caps.drop all
# net none
netfilter
nodvd
nogroups
nonewprivs
noroot
notv
# novideo
seccomp

private-dev

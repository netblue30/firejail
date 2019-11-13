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

caps.drop all
# net none
netfilter
nodvd
nogroups
nonewprivs
noroot
notv
# novideo
# if seccomp breaks your program, add !ptrace to the next line
seccomp

private-dev

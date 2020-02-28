# Firejail profile for playonlinux
# Description: Front-end for Wine
# This file is overwritten after every install/update
# Persistent local customizations
include playonlinux.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.Steam
noblacklist ${HOME}/.local/share/Steam
noblacklist ${HOME}/.local/share/steam
noblacklist ${HOME}/.steam
noblacklist ${HOME}/.PlayOnLinux

# netcat is needed to run playonlinux
noblacklist ${PATH}/nc
noblacklist ${PATH}/nc.openbsd
noblacklist ${PATH}/nc.traditional
noblacklist ${PATH}/ncat

# Allow python (blacklisted by disable-interpreters.inc)
include allow-python2.inc
include allow-python3.inc

# Allow perl (blacklisted by disable-interpreters.inc)
include allow-perl.inc

include disable-common.inc
include disable-devel.inc
include disable-interpreters.inc
include disable-programs.inc

caps.drop all
netfilter
nodvd
nogroups
nonewprivs
noroot
notv
seccomp

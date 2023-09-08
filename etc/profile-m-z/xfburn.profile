# Firejail profile for xfburn
# Description: CD-burner application for Xfce Desktop Environment
# This file is overwritten after every install/update
# Persistent local customizations
include xfburn.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.config/xfburn

include disable-common.inc
include disable-devel.inc
include disable-interpreters.inc
include disable-programs.inc

caps.drop all
netfilter
nogroups
nonewprivs
noroot
nosound
notv
novideo
protocol unix
seccomp
tracelog

#private-bin xfburn
#private-dev
#private-tmp

restrict-namespaces

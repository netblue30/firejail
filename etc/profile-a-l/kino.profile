# Firejail profile for kino
# Description: Non-linear editor for Digital Video data
# This file is overwritten after every install/update
# Persistent local customizations
include kino.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.kino-history
noblacklist ${HOME}/.kinorc

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc

include whitelist-var-common.inc

apparmor
caps.drop all
netfilter
nogroups
noinput
nonewprivs
noroot
notv
nou2f
novideo
protocol unix
seccomp
shell none

private-cache
private-dev
private-tmp


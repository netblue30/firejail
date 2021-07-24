# Firejail profile for tuxguitar
# Description: Multitrack guitar tablature editor and player (gp3 to gp5)
# This file is overwritten after every install/update
# Persistent local customizations
include tuxguitar.local
# Persistent global definitions
include globals.local

# tuxguitar fails to launch
ignore noexec ${HOME}

nodeny  ${HOME}/.tuxguitar*
nodeny  ${DOCUMENTS}
nodeny  ${MUSIC}

# Allow java (blacklisted by disable-devel.inc)
include allow-java.inc

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc
include disable-xdg.inc

include whitelist-var-common.inc

apparmor
caps.drop all
netfilter
no3d
nodvd
nogroups
noinput
nonewprivs
noroot
notv
nou2f
novideo
protocol unix,inet,inet6
seccomp
tracelog

private-dev
private-tmp

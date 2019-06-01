# Firejail profile for tuxguitar
# Description: Multitrack guitar tablature editor and player (gp3 to gp5)
# This file is overwritten after every install/update
# Persistent local customizations
include tuxguitar.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.java
noblacklist ${HOME}/.tuxguitar*
noblacklist ${DOCUMENTS}
noblacklist ${MUSIC}

# Allow java (blacklisted by disable-interpreters.inc)
include allow-java.inc

include disable-common.inc
include disable-devel.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc
include disable-xdg.inc

include whitelist-var-common.inc

caps.drop all
netfilter
no3d
nodvd
nogroups
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

# noexec ${HOME} - tuxguitar may fail to launch
noexec /tmp

# Firejail profile for tuxguitar
# Description: Multitrack guitar tablature editor and player (gp3 to gp5)
# This file is overwritten after every install/update
# Persistent local customizations
include /etc/firejail/tuxguitar.local
# Persistent global definitions
include /etc/firejail/globals.local

noblacklist ${HOME}/.java
noblacklist ${HOME}/.tuxguitar*
noblacklist ${DOCUMENTS}
noblacklist ${MUSIC}

# Allow access to java
noblacklist ${PATH}/java
noblacklist /usr/lib/java
noblacklist /etc/java
noblacklist /usr/share/java

include /etc/firejail/disable-common.inc
include /etc/firejail/disable-devel.inc
include /etc/firejail/disable-interpreters.inc
include /etc/firejail/disable-passwdmgr.inc
include /etc/firejail/disable-programs.inc
include /etc/firejail/disable-xdg.inc

include /etc/firejail/whitelist-var-common.inc

caps.drop all
netfilter
no3d
nodvd
nogroups
nonewprivs
noroot
notv
novideo
protocol unix,inet,inet6
seccomp
tracelog

private-dev
private-tmp

# noexec ${HOME} - tuxguitar may fail to launch
noexec /tmp

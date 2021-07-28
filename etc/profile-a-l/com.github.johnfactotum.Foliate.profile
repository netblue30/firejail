# Firejail profile for foliate
# Description: Simple and modern GTK eBook reader
# This file is overwritten after every install/update
# Persistent local customizations
include foliate.local
# Persistent global definitions
include globals.local

noblacklist ${DOCUMENTS}
noblacklist ${HOME}/.cache/com.github.johnfactotum.Foliate
noblacklist ${HOME}/.local/share/com.github.johnfactotum.Foliate

# Allow gjs (blacklisted by disable-interpreters.inc)
include allow-gjs.inc

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc
include disable-shell.inc
include disable-xdg.inc

mkdir ${HOME}/.cache/com.github.johnfactotum.Foliate
mkdir ${HOME}/.local/share/com.github.johnfactotum.Foliate
whitelist ${HOME}/.cache/com.github.johnfactotum.Foliate
whitelist ${HOME}/.local/share/com.github.johnfactotum.Foliate
whitelist ${DOCUMENTS}
whitelist ${DOWNLOADS}
whitelist /usr/share/com.github.johnfactotum.Foliate
whitelist /usr/share/hyphen
include whitelist-common.inc
include whitelist-usr-share-common.inc
include whitelist-var-common.inc

apparmor
caps.drop all
machine-id
net none
nodvd
nogroups
noinput
nonewprivs
noroot
nosound
notv
nou2f
novideo
protocol unix
seccomp
shell none
tracelog

disable-mnt
private-bin com.github.johnfactotum.Foliate,gjs
private-cache
private-dev
private-etc dconf,fonts,gconf,gtk-3.0
private-tmp

read-only ${HOME}
read-write ${HOME}/.cache/com.github.johnfactotum.Foliate
read-write ${HOME}/.local/share/com.github.johnfactotum.Foliate

# Firejail profile for notejot
# Description: Jot your ideas
# This file is overwritten after every install/update
# Persistent local customizations
include io.github.lainsce.Notejot.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.cache/io.github.lainsce.Notejot
noblacklist ${HOME}/.local/share/io.github.lainsce.Notejot

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-programs.inc
include disable-shell.inc
include disable-xdg.inc

mkdir ${HOME}/.cache/io.github.lainsce.Notejot
mkdir ${HOME}/.local/share/io.github.lainsce.Notejot
whitelist ${HOME}/.cache/io.github.lainsce.Notejot
whitelist ${HOME}/.local/share/io.github.lainsce.Notejot
whitelist /usr/libexec/webkit2gtk-4.0
include whitelist-common.inc
include whitelist-runuser-common.inc
include whitelist-usr-share-common.inc
include whitelist-var-common.inc

apparmor
caps.drop all
machine-id
net none
no3d
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
seccomp.block-secondary
tracelog

disable-mnt
private-bin io.github.lainsce.Notejot
private-cache
private-dev
private-etc @x11
private-tmp

dbus-user filter
dbus-user.own io.github.lainsce.Notejot
dbus-user.talk ca.desrt.dconf
dbus-system none

restrict-namespaces

# Firejail profile for ocenaudio
# Description: Cross-platform, easy to use, fast and functional audio editor
# This file is overwritten after every install/update
# Persistent local customizations
include ocenaudio.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.cache/ocenaudio
noblacklist ${HOME}/.local/share/ocenaudio

noblacklist ${MUSIC}

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-programs.inc
include disable-shell.inc
include disable-xdg.inc

mkdir ${HOME}/.cache/ocenaudio
mkdir ${HOME}/.local/share/ocenaudio
whitelist ${HOME}/.cache/ocenaudio
whitelist ${HOME}/.local/share/ocenaudio
whitelist ${DOWNLOADS}
whitelist ${MUSIC}
include whitelist-common.inc
include whitelist-run-common.inc
include whitelist-runuser-common.inc
include whitelist-usr-share-common.inc
include whitelist-var-common.inc

apparmor
caps.drop all
#ipc-namespace
netfilter
no3d
nodvd
nogroups
noinput
nonewprivs
noprinters
noroot
notv
nou2f
novideo
# Add `protocol unix\nignore protocol` to your ocenaudio.local to disable networking.
protocol unix,inet,inet6
seccomp
tracelog

private-bin ocenaudio,ocenvst
private-cache
private-dev
private-etc alternatives,asound.conf,ca-certificates,crypto-policies,dconf,fonts,group,gtk-2.0,gtk-3.0,hostname,hosts,ld.so.cache,ld.so.conf,ld.so.conf.d,ld.so.preload,mime.types,nsswitch.conf,pki,pulse,resolv.conf,ssl,X11,xdg
private-opt ocenaudio
private-tmp

dbus-user none
dbus-system none

restrict-namespaces

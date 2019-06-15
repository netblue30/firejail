# Firejail profile for celluloid
# Description: Simple GTK+ frontend for mpv
# This file is overwritten after every install/update
# Persistent local customizations
include celluloid.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.config/gnome-mpv
noblacklist ${HOME}/.config/celluloid
noblacklist ${MUSIC}
noblacklist ${VIDEOS}

# Allow python (blacklisted by disable-interpreters.inc)
include allow-python2.inc
include allow-python3.inc

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
nodbus
nogroups
nonewprivs
noroot
nou2f
protocol unix,inet,inet6
seccomp
shell none
tracelog

private-bin celluloid,env,gnome-mpv,python*,youtube-dl
private-cache
private-etc alternatives,ca-certificates,crypto-policies,dconf,drirc,fonts,gtk-3.0,hosts,libva.conf,localtime,machine-id,pkcs11,pki,resolv.conf,selinux,ssl,xdg
private-dev
private-tmp


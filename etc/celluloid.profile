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
noblacklist ${PATH}/python2*
noblacklist ${PATH}/python3*
noblacklist /usr/lib/python2*
noblacklist /usr/lib/python3*
noblacklist /usr/local/lib/python2*
noblacklist /usr/local/lib/python3*

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

private-bin celluloid,gnome-mpv,youtube-dl,python*,env
private-cache
private-etc alternatives,ca-certificates,ssl,pki,pkcs11,hosts,machine-id,localtime,libva.conf,drirc,fonts,gtk-3.0,dconf,crypto-policies,xdg,selinux,resolv.conf
private-dev
private-tmp


# Firejail profile for Mendeley
# Description: Academic software for managing and sharing research papers.
# This file is overwritten after every install/update
# Persistent local customizations
include mendeleydesktop.local
# Persistent global definitions
include globals.local

noblacklist ${DOCUMENTS}
noblacklist ${HOME}/.cache/Mendeley Ltd.
noblacklist ${HOME}/.config/Mendeley Ltd.
noblacklist ${HOME}/.local/share/Mendeley Ltd.
noblacklist ${HOME}/.local/share/data/Mendeley Ltd.
noblacklist ${HOME}/.pki
noblacklist ${HOME}/.local/share/pki

# Allow python (blacklisted by disable-interpreters.inc)
include allow-python2.inc
include allow-python3.inc

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc

include whitelist-var-common.inc

caps.drop all
netfilter
nodbus
nodvd
nogroups
nonewprivs
noroot
notv
nou2f
novideo
protocol unix,inet,inet6,netlink
seccomp
shell none
tracelog

disable-mnt
private-bin cat,env,gconftool-2,ln,mendeleydesktop,python*,sh,update-desktop-database,which
private-dev
#private-etc Trolltech.conf,X11,alsa,alternatives,asound.conf,bumblebee,ca-certificates,crypto-policies,dconf,drirc,fonts,gconf,glvnd,gtk-2.0,gtk-3.0,hosts,host.conf,hostname,ld.so.cache,ld.so.preload,ld.so.conf,ld.so.conf.d,locale,locale.alias,locale.conf,localtime,machine-id,mime.types,nsswitch.conf,pango,passwd,pki,protocols,pulse,resolv.conf,rpc,services,ssl,xdg
private-tmp


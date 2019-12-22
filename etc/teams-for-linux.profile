# Firejail profile for teams-for-linux
# Description: Teams for Linux is an Electron application for Microsoft's team collaboration and chat program
# This file is overwritten after every install/update
# Persistent local customizations
include teams-for-linux.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.config/teams-for-linux

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc

mkdir ${HOME}/.config/teams-for-linux
whitelist ${HOME}/.config/teams-for-linux
whitelist ${DOWNLOADS}
include whitelist-common.inc
include whitelist-var-common.inc

caps.drop all
netfilter
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

disable-mnt
private-bin bash,cut,echo,egrep,grep,head,sed,sh,teams-for-linux,tr,xdg-mime,xdg-open,zsh
private-cache
private-dev
private-etc Trolltech.conf,X11,alsa,alternatives,asound.conf,bumblebee,ca-certificates,crypto-policies,dbus-1,dconf,drirc,fonts,gconf,glvnd,gtk-2.0,gtk-3.0,hosts,host.conf,hostname,ld.so.cache,ld.so.preload,ld.so.conf,ld.so.conf.d,locale,locale.alias,locale.conf,localtime,machine-id,mime.types,nsswitch.conf,pango,passwd,pki,protocols,pulse,resolv.conf,rpc,services,ssl,xdg
private-tmp

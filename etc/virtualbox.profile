# Firejail profile for virtualbox
# Description: x86 virtualization solution
# This file is overwritten after every install/update
# Persistent local customizations
include virtualbox.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.VirtualBox
noblacklist ${HOME}/.config/VirtualBox
noblacklist ${HOME}/VirtualBox VMs
# noblacklist /usr/bin/virtualbox
noblacklist /usr/lib/virtualbox
noblacklist /usr/lib64/virtualbox

include disable-common.inc
include disable-exec.inc
include disable-passwdmgr.inc
include disable-programs.inc

mkdir ${HOME}/.config/VirtualBox
mkdir ${HOME}/VirtualBox VMs
whitelist ${HOME}/.config/VirtualBox
whitelist ${HOME}/VirtualBox VMs
whitelist ${DOWNLOADS}
include whitelist-common.inc
include whitelist-var-common.inc

caps.keep net_raw,sys_admin,sys_nice
netfilter
nodvd
notv

private-etc Trolltech.conf,X11,alsa,alternatives,asound.conf,bumblebee,ca-certificates,crypto-policies,dbus-1,dconf,default,drirc,fonts,gconf,glvnd,group,gtk-2.0,gtk-3.0,hosts,host.conf,hostname,ld.so.cache,ld.so.preload,ld.so.conf,ld.so.conf.d,locale,locale.alias,locale.conf,localtime,machine-id,mime.types,nsswitch.conf,pango,passwd,pki,protocols,pulse,resolv.conf,rpc,services,ssl,vbox,xdg

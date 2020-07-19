include vmware.local


include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc
include disable-xdg.inc


#caps.drop all
caps.keep sys_nice
ipc-namespace
netfilter
nodbus
# dbus-user none
# dbus-system none
nogroups
notv
shell none

whitelist ${HOME}/.vmware
whitelist ${HOME}/.cache/vmware

include whitelist-common.inc


#disable-mnt


private-etc private-etc alsa,asound.conf,ca-certificates,conf.d,dconf,fonts,gtk-2.0,gtk-3.0,hostname,hosts,ld.so.cache,localtime,machine-id,pulse,resolv.conf,ssl,vmware,vmware-installer,vmware-vix,X11

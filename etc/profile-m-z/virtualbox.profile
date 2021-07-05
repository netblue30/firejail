# Firejail profile for virtualbox
# Description: x86 virtualization solution
# This file is overwritten after every install/update
# Persistent local customizations
include virtualbox.local
# Persistent global definitions
include globals.local

nodeny  ${HOME}/.VirtualBox
nodeny  ${HOME}/.config/VirtualBox
nodeny  ${HOME}/VirtualBox VMs
# noblacklist /usr/bin/virtualbox
nodeny  /usr/lib/virtualbox
nodeny  /usr/lib64/virtualbox

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc
include disable-xdg.inc

mkdir ${HOME}/.config/VirtualBox
mkdir ${HOME}/VirtualBox VMs
allow  ${HOME}/.config/VirtualBox
allow  ${HOME}/VirtualBox VMs
allow  ${DOWNLOADS}
allow  /usr/share/virtualbox
include whitelist-common.inc
include whitelist-runuser-common.inc
include whitelist-usr-share-common.inc
include whitelist-var-common.inc

# For host-only network sys_admin is needed. See https://github.com/netblue30/firejail/issues/2868#issuecomment-518647630

apparmor
caps.keep net_raw,sys_nice
netfilter
nodvd
#nogroups
notv
shell none
tracelog

#disable-mnt
#private-bin awk,basename,bash,env,gawk,grep,ps,readlink,sh,virtualbox,VirtualBox,VBox*,vbox*,whoami
private-cache
private-etc alsa,asound.conf,ca-certificates,conf.d,crypto-policies,dconf,fonts,hostname,hosts,ld.so.cache,localtime,machine-id,pki,pulse,resolv.conf,ssl
private-tmp

dbus-user none
dbus-system none

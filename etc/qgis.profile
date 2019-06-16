# Firejail profile for qgis
# Description: GIS application
# This file is overwritten after every install/update
# Persistent local customizations
include qgis.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.config/QGIS
noblacklist ${HOME}/.local/share/QGIS
noblacklist ${HOME}/.qgis2
noblacklist ${DOCUMENTS}

# Allow python (blacklisted by disable-interpreters.inc)
include allow-python3.inc

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc
include disable-xdg.inc

mkdir ${HOME}/.local/share/QGIS
mkdir ${HOME}/.qgis2
mkdir ${HOME}/.config/QGIS
whitelist ${HOME}/.local/share/QGIS
whitelist ${HOME}/.qgis2
whitelist ${HOME}/.config/QGIS
whitelist ${DOCUMENTS}
include whitelist-common.inc
include whitelist-var-common.inc

caps.drop all
netfilter
machine-id
nodbus
nodvd
nogroups
nonewprivs
noroot
nosound
notv
nou2f
novideo
# blacklisting of mbind system calls breaks old version
seccomp.drop @cpu-emulation,@debug,@obsolete,@privileged,add_key,fanotify_init,io_cancel,io_destroy,io_getevents,io_setup,io_submit,ioprio_set,kcmp,keyctl,migrate_pages,mincore,move_pages,name_to_handle_at,ni_syscall,open_by_handle_at,remap_file_pages,request_key,set_mempolicy,syslog,umount,userfaultfd,vmsplice
protocol unix,inet,inet6,netlink
shell none
tracelog

disable-mnt
private-cache
private-dev
private-etc alternatives,ca-certificates,crypto-policies,fonts,machine-id,pki,QGIS,QGIS.conf,resolv.conf,ssl,Trolltech.conf
private-tmp

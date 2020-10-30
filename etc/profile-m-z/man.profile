# Firejail profile for man
# Description: manpage viewer
quiet
# This file is overwritten after every install/update
# Persistent local customizations
include man.local
# Persistent global definitions
include globals.local

blacklist ${RUNUSER}

noblacklist ${HOME}/.local/share/man

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc
include disable-xdg.inc

mkdir ${HOME}/.local/share/man
whitelist ${HOME}/.local/share/man
whitelist ${HOME}/.manpath
whitelist /usr/share/groff
whitelist /usr/share/info
whitelist /usr/share/lintian
whitelist /usr/share/locale
whitelist /usr/share/man
whitelist /var/cache/man
include whitelist-common.inc
include whitelist-usr-share-common.inc
include whitelist-var-common.inc

apparmor
caps.drop all
ipc-namespace
machine-id
net none
no3d
nodvd
nogroups
nonewprivs
noroot
nosound
notv
novideo
nou2f
protocol unix
seccomp
shell none
tracelog
x11 none

disable-mnt
private-bin apropos,bash,cat,catman,col,gpreconv,groff,grotty,gunzip,gzip,less,man,most,nroff,preconv,sed,sh,tbl,tr,troff,whatis,which,xtotroff,zcat,zsoelim
private-cache
private-dev
private-etc alternatives,fonts,locale,locale.alias,locale.conf,man_db.conf,manpath.config,selinux,sysless,xdg
private-tmp

dbus-user none
dbus-system none

memory-deny-write-execute

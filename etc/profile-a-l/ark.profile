# Firejail profile for ark
# Description: Archive utility
# This file is overwritten after every install/update
# Persistent local customizations
include ark.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.config/arkrc
noblacklist ${HOME}/.local/share/kxmlgui5/ark

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-programs.inc

whitelist /usr/share/ark
include whitelist-run-common.inc
include whitelist-usr-share-common.inc
include whitelist-var-common.inc

apparmor
caps.drop all
#net none
netfilter
nodvd
nogroups
noinput
nonewprivs
noroot
nosound
notv
nou2f
novideo
protocol unix
seccomp

private-bin 7z,ark,bash,lrzip,lsar,lz4,lzop,p7zip,rar,sh,tclsh,unar,unrar,unzip,zip,zipinfo
#private-etc alternatives,drirc,fonts,group,kde5rc,mtab,passwd,samba,smb.conf,xdg

private-dev
private-tmp

#dbus-user none
#dbus-system none

restrict-namespaces

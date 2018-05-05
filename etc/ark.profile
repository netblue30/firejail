# Firejail profile for ark
# This file is overwritten after every install/update
# Persistent local customizations
include /etc/firejail/ark.local
# Persistent global definitions
include /etc/firejail/globals.local

noblacklist ${HOME}/.config/arkrc

include /etc/firejail/disable-common.inc
include /etc/firejail/disable-devel.inc
include /etc/firejail/disable-interpreters.inc
include /etc/firejail/disable-passwdmgr.inc
include /etc/firejail/disable-programs.inc

include /etc/firejail/whitelist-var-common.inc

apparmor
caps.drop all
# net none
netfilter
# nodbus
nodvd
nogroups
nonewprivs
noroot
nosound
notv
novideo
protocol unix
seccomp
shell none

private-bin ark,unrar,rar,unzip,zip,zipinfo,7z,unar,lsar,lrzip,lzop,lz4
#private-etc smb.conf,samba,mtab,fonts,drirc,kde5rc,passwd,group,xdg

private-dev
private-tmp

noexec ${HOME}
noexec /tmp

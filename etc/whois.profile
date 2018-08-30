quiet
# Firejail profile for whois
# This file is overwritten after every install/update
# Persistent local customizations
include /etc/firejail/whois.local
# Persistent global definitions
include /etc/firejail/globals.local

include /etc/firejail/disable-common.inc
# include /etc/firejail/disable-devel.inc
# include /etc/firejail/disable-interpreters.inc
include /etc/firejail/disable-passwdmgr.inc
include /etc/firejail/disable-programs.inc
#include /etc/firejail/disable-xdg.inc

include /etc/firejail/whitelist-var-common.inc

caps.drop all
# ipc-namespace
netfilter
no3d
nodbus
nodvd
nogroups
nonewprivs
noroot
nosound
notv
novideo
protocol inet,inet6
seccomp
shell none

disable-mnt
private
private-bin sh,bash,whois
private-cache
private-dev
# private-etc hosts,services,whois.conf
private-lib
private-tmp

memory-deny-write-execute
# noexec ${HOME}
# noexec /tmp

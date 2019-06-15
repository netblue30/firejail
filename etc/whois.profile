# Firejail profile for whois
# Description: Intelligent WHOIS client
quiet
# This file is overwritten after every install/update
# Persistent local customizations
include whois.local
# Persistent global definitions
include globals.local

include disable-common.inc
# include disable-devel.inc
include disable-exec.inc
# include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc
#include disable-xdg.inc

include whitelist-var-common.inc

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
nou2f
novideo
protocol inet,inet6
seccomp
shell none

disable-mnt
private
private-bin bash,sh,whois
private-cache
private-dev
# private-etc alternatives,hosts,services,whois.conf
private-lib
private-tmp

memory-deny-write-execute

# Firejail profile for silentarmy
# This file is overwritten after every install/update
# Persistent local customizations
include silentarmy.local
# Persistent global definitions
include globals.local


include disable-common.inc
# include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc
include disable-xdg.inc

include whitelist-var-common.inc

caps.drop all
netfilter
nodvd
nogroups
nonewprivs
noroot
nosound
notv
nou2f
novideo
protocol unix,inet,inet6
seccomp
shell none

disable-mnt
private
private-bin python*,sa-solver,silentarmy
private-dev
#private-etc alternatives,bumblebee,ca-certificates,crypto-policies,dbus-1,drirc,glvnd,hosts,host.conf,hostname,ld.so.cache,ld.so.preload,ld.so.conf,ld.so.conf.d,locale,locale.alias,locale.conf,localtime,machine-id,mime.types,nsswitch.conf,passwd,pki,protocols,resolv.conf,rpc,services,ssl,xdg
private-opt none
private-tmp


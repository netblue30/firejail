# Firejail profile for redeclipse
# Description: Free, casual arena shooter
# This file is overwritten after every install/update
# Persistent local customizations
include redeclipse.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.redeclipse

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-programs.inc
include disable-xdg.inc

mkdir ${HOME}/.redeclipse
whitelist ${HOME}/.redeclipse
whitelist /usr/share/redeclipse
include whitelist-common.inc
include whitelist-runuser-common.inc
include whitelist-usr-share-common.inc
include whitelist-var-common.inc

caps.drop all
netfilter
nodvd
nogroups
noinput
nonewprivs
noroot
notv
nou2f
novideo
protocol unix,inet,inet6
seccomp
shell none
tracelog

disable-mnt
#private-bin redeclipse,sh,man
private-cache
private-dev
private-tmp

dbus-user none
dbus-system none

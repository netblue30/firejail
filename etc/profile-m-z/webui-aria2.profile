# Firejail profile for webui-aria2
# Run this with firejail --profile=webui-aria2 node node-server.js
# This file is overwritten after every install/update
# Persistent local customizations
include webui-aria2.local
# Persistent global definitions
include globals.local

nodeny  ${PATH}/node

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc
include disable-xdg.inc

caps.drop all
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
protocol unix,inet,inet6
seccomp
shell none

private-cache
private-dev
private-tmp

dbus-user none
dbus-system none

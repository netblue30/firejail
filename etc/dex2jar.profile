# Firejail profile for dex2jar
# This file is overwritten after every install/update
quiet
# Persistent local customizations
include dex2jar.local
# Persistent global definitions
include globals.local

# Allow java (blacklisted by disable-interpreters.inc)
include allow-java.inc

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc
include disable-xdg.inc

include whitelist-var-common.inc

caps.drop all
net none
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
protocol unix
seccomp
shell none

private-bin dex2jar,java,sh,bash,expr,dirname,ls,uname,grep
private-cache
private-dev


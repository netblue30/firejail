# Firejail profile for freemind
# Description: Free mind mapping software
# This file is overwritten after every install/update
# Persistent local customizations
include freemind.local
# Persistent global definitions
include globals.local

noblacklist ${DOCUMENTS}
noblacklist ${HOME}/.freemind

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

apparmor
caps.drop all
machine-id
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
protocol unix,inet,inet6
seccomp
shell none
tracelog

disable-mnt
private-bin freemind,java,bash,sed,sh,grep,mkdir,echo,cp,uname,which,lsb_release,rpm,dpkg,dirname,readlink
private-cache
private-dev
#private-etc alternatives,fonts,java
private-tmp
private-opt none
private-srv none

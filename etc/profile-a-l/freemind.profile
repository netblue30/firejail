# Firejail profile for freemind
# Description: Free mind mapping software
# This file is overwritten after every install/update
# Persistent local customizations
include freemind.local
# Persistent global definitions
include globals.local

noblacklist ${DOCUMENTS}
noblacklist ${HOME}/.freemind

noblacklist ${PATH}/dpkg*

# Allow java (blacklisted by disable-devel.inc)
include allow-java.inc

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-programs.inc
include disable-xdg.inc

include whitelist-var-common.inc

apparmor
caps.drop all
machine-id
netfilter
no3d
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
tracelog

disable-mnt
private-bin bash,cp,dirname,dpkg*,echo,freemind,grep,java,lsb_release,mkdir,readlink,rpm,sed,sh,uname,which
private-cache
private-dev
#private-etc alternatives,fonts,java*
private-tmp
private-opt none
private-srv none

dbus-user none
dbus-system none

restrict-namespaces

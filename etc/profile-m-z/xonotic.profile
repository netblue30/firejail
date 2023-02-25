# Firejail profile for xonotic
# Description: A free, fast-paced crossplatform first-person shooter
# This file is overwritten after every install/update
# Persistent local customizations
include xonotic.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.xonotic

include allow-bin-sh.inc
include allow-opengl-game.inc

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-programs.inc
include disable-shell.inc
include disable-xdg.inc

mkdir ${HOME}/.xonotic
whitelist ${HOME}/.xonotic
whitelist /usr/share/xonotic
include whitelist-common.inc
include whitelist-runuser-common.inc
include whitelist-usr-share-common.inc
include whitelist-var-common.inc

apparmor
caps.drop all
netfilter
nodvd
nogroups
nonewprivs
noroot
notv
nou2f
novideo
protocol unix,inet,inet6
seccomp
tracelog

disable-mnt
private-cache
private-bin blind-id,darkplaces-glx,darkplaces-sdl,dirname,ldd,netstat,ps,readlink,sh,uname,xonotic*
private-dev
private-etc @tls-ca,@x11,host.conf
private-tmp

dbus-user none
dbus-system none

read-only ${HOME}
read-write ${HOME}/.xonotic
restrict-namespaces

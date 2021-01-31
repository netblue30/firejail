# Firejail profile for Avidemux
# Description: Avidemux is a free video editor designed for simple cutting, filtering and encoding tasks.
# Persistent local customizations
include avidemux.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.avidemux6
noblacklist ${HOME}/.config/avidemux3_qt5rc
noblacklist ${VIDEOS}

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc
include disable-shell.inc
include disable-xdg.inc

mkdir ${HOME}/.avidemux6
mkdir ${HOME}/.config/avidemux3_qt5rc
whitelist ${HOME}/.avidemux6
whitelist ${HOME}/.config/avidemux3_qt5rc
whitelist ${VIDEOS}
include whitelist-common.inc
include whitelist-runuser-common.inc
include whitelist-usr-share-common.inc
include whitelist-var-common.inc

apparmor
caps.drop all
net none
nodvd
nogroups
nonewprivs
noroot
notv
nou2f
novideo
protocol unix
seccomp
seccomp.block-secondary
shell none
tracelog

private-bin avidemux3_cli,avidemux3_jobs_qt5,avidemux3_qt5
private-cache
private-dev
private-tmp

dbus-user none
dbus-system none

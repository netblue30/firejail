# Firejail profile for Avidemux
# Description: Avidemux is a free video editor designed for simple cutting, filtering and encoding tasks.
# This file is overwritten after every install/update
# Persistent local customizations
include avidemux.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.avidemux3
noblacklist ${HOME}/.avidemux6
noblacklist ${HOME}/.config/avidemux3_qt5rc
noblacklist ${VIDEOS}

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-programs.inc
include disable-shell.inc
include disable-xdg.inc

mkdir ${HOME}/.avidemux3
mkdir ${HOME}/.avidemux6
mkdir ${HOME}/.config/avidemux3_qt5rc
whitelist ${HOME}/.avidemux3
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
noinput
nonewprivs
noroot
notv
nou2f
novideo
protocol unix
seccomp
seccomp.block-secondary
tracelog

private-bin avidemux3_cli,avidemux3_jobs_qt5,avidemux3_qt5
private-cache
private-dev
private-tmp

dbus-user none
dbus-system none

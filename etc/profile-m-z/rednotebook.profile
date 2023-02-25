# Firejail profile for rednotebook
# Description: Daily journal with calendar, templates and keyword searching
# This file is overwritten after every install/update
# Persistent local customizations
include rednotebook.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.cache/rednotebook
noblacklist ${HOME}/.rednotebook

# Allow python (blacklisted by disable-interpreters.inc)
include allow-python3.inc

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-programs.inc
include disable-shell.inc

mkdir ${HOME}/.cache/rednotebook
mkdir ${HOME}/.rednotebook
whitelist ${HOME}/.cache/rednotebook
whitelist ${HOME}/.rednotebook
whitelist ${DESKTOP}
whitelist ${DOCUMENTS}
whitelist ${DOWNLOADS}
whitelist ${MUSIC}
whitelist ${PICTURES}
whitelist ${VIDEOS}
whitelist /usr/libexec/webkit2gtk-4.0
include whitelist-common.inc
include whitelist-runuser-common.inc
include whitelist-usr-share-common.inc
include whitelist-var-common.inc

apparmor
caps.drop all
machine-id
net none
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
protocol unix
seccomp
seccomp.block-secondary
tracelog

disable-mnt
private-bin python3*,rednotebook
private-cache
private-dev
private-etc @x11
private-tmp

dbus-user none
dbus-system none

restrict-namespaces

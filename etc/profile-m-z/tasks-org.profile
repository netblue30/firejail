# Firejail profile for tasks-org
# Description: Tasks.org Open-source To-Do Lists & Reminders
# This file is overwritten after every install/update
# Persistent local customizations
include tasks-org.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.local/share/tasks.org
noblacklist ${HOME}/.local/state/tasks.org

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-programs.inc
include disable-shell.inc
include disable-xdg.inc

mkdir ${HOME}/.local/share/tasks.org
mkdir ${HOME}/.local/state/tasks.org
whitelist ${HOME}/.local/share/tasks.org
whitelist ${HOME}/.local/state/tasks.org
include whitelist-common.inc
include whitelist-runuser-common.inc
include whitelist-usr-share-common.inc
include whitelist-var-common.inc

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

disable-mnt
private-cache
private-dev
private-etc @network,@tls-ca,@x11
private-tmp

dbus-system none

restrict-namespaces

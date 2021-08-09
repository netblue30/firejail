# Firejail profile for JDownloader
# This file is overwritten after every install/update
# Persistent local customizations
include JDownloader.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.jd

# Allow java (blacklisted by disable-devel.inc)
include allow-java.inc

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-programs.inc
include disable-xdg.inc

mkdir ${HOME}/.jd
whitelist ${HOME}/.jd
whitelist ${DOWNLOADS}
include whitelist-common.inc
include whitelist-var-common.inc

caps.drop all
ipc-namespace
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
shell none

private-cache
private-dev
private-tmp

dbus-user none
dbus-system none

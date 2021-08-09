# Firejail profile for zulip
# Description: Real-time team chat based on the email threading model
# This file is overwritten after every install/update
# Persistent local customizations
include zulip.local
# Persistent global definitions
include globals.local

ignore noexec /tmp

noblacklist ${HOME}/.config/Zulip

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-programs.inc
include disable-shell.inc
include disable-xdg.inc

mkdir ${HOME}/.config/Zulip
whitelist ${HOME}/.config/Zulip
whitelist ${DOWNLOADS}
include whitelist-common.inc
include whitelist-var-common.inc

apparmor
caps.drop all
netfilter
no3d
nodvd
nogroups
noinput
nonewprivs
noroot
notv
nou2f
novideo
protocol unix,inet,inet6
seccomp
shell none

disable-mnt
private-bin locale,zulip
private-cache
private-dev
private-etc asound.conf,fonts,machine-id
private-tmp

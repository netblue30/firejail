# Firejail profile for Halloy
# Description: Modern IRC client
# This file is overwritten after every install/update
# Persistent local customizations
include halloy.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.cache/halloy
noblacklist ${HOME}/.config/halloy
noblacklist ${HOME}/.local/share/halloy

blacklist /usr/libexec

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-proc.inc
include disable-programs.inc
include disable-shell.inc
include disable-xdg.inc

mkdir ${HOME}/.cache/halloy
mkdir ${HOME}/.config/halloy
mkdir ${HOME}/.local/share/halloy
whitelist ${HOME}/.cache/halloy
whitelist ${HOME}/.config/halloy
whitelist ${HOME}/.local/share/halloy
include whitelist-common.inc
include whitelist-runuser-common.inc
include whitelist-usr-share-common.inc
include whitelist-var-common.inc

apparmor
caps.drop all
ipc-namespace
netfilter
# Currently hardware acceleration is on by default.
# There is no option to turn it off:
# https://github.com/squidowl/halloy/issues/669
#no3d
nodvd
nogroups
nonewprivs
noprinters
noroot
notv
nou2f
novideo
protocol unix,inet,inet6
seccomp
seccomp.block-secondary
tracelog

disable-mnt
private-cache
private-dev
private-tmp

dbus-system none

restrict-namespaces

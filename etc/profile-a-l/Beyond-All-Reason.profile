# Firejail profile for Beyond All Reason
# Description: Open source real time strategy game
# This file is overwritten after every install/update
# Persistent local customizations
include Beyond-All-Reason.local
# Persistent global definitions
include globals.local

blacklist /usr/libexec

include disable-common.inc
include disable-devel.inc
#include disable-exec.inc # game cannot start if enabled
include disable-interpreters.inc
include disable-programs.inc
include disable-shell.inc
include disable-xdg.inc

mkdir ${HOME}/Beyond All Reason
whitelist ${HOME}/Beyond All Reason
whitelist ${DOWNLOADS}
#include whitelist-common.inc # causes program to look in $HOME/Documents instead of $HOME
include whitelist-runuser-common.inc
include whitelist-usr-share-common.inc
include whitelist-var-common.inc

caps.drop all
netfilter
dbus-system none
nodvd
nogroups
noinput
nonewprivs
noroot
notv
nou2f
novideo
protocol unix,inet,inet6
#seccomp # crashes the launcher
shell none
#tracelog # launcher never starts

disable-mnt
private-cache
private-dev
private-etc ca-certificates,crypto-policies,machine-id,pki,resolv.conf,ssl
private-tmp

# Firejail profile for ssmtp
# Description: Extremely simple MTA to get mail off the system to a mailhub
# This file is overwritten after every install/update
quiet
# Persistent local customizations
include ssmtp.local
# Persistent global definitions
include globals.local

blacklist ${RUNUSER}
blacklist /usr/libexec

noblacklist /etc/logcheck
noblacklist /etc/ssmtp
noblacklist /sbin
noblacklist /usr/sbin

noblacklist ${DOCUMENTS}
noblacklist ${PATH}/ssmtp
include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-proc.inc
include disable-programs.inc
include disable-shell.inc
include disable-x11.inc
include disable-xdg.inc

mkfile ${HOME}/dead.letter
whitelist ${HOME}/dead.letter
whitelist ${DOCUMENTS}
whitelist ${DOWNLOADS}
include whitelist-common.inc
include whitelist-run-common.inc
include whitelist-runuser-common.inc
include whitelist-usr-share-common.inc
include whitelist-var-common.inc

apparmor
caps.drop all
ipc-namespace
machine-id
netfilter
no3d
nodvd
#nogroups breaks app
noinput
nonewprivs
noprinters
#noroot breaks app
nosound
notv
nou2f
novideo
protocol unix,inet,inet6
seccomp
seccomp.block-secondary
tracelog

disable-mnt
# private works but then we lose ${HOME}/dead.letter
# which is useful to get notified on mail issues
#private
private-bin mailq,newaliases,sendmail,ssmtp
private-cache
private-dev
private-tmp

dbus-user none
dbus-system none

memory-deny-write-execute
restrict-namespaces
read-only ${HOME}
read-write ${HOME}/dead.letter

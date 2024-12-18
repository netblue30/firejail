# Firejail profile for alpine
# Description: Text-based email and newsgroups reader
# This file is overwritten after every install/update
quiet
# Persistent local customizations
include alpine.local
# Persistent global definitions
include globals.local

# Workaround for bug https://github.com/netblue30/firejail/issues/2747
# firejail --private-bin=sh --include='${CFG}/allow-bin-sh.inc' --profile=alpine sh -c '(alpine)'

noblacklist /var/mail
noblacklist /var/spool/mail
noblacklist ${DOCUMENTS}
noblacklist ${HOME}/.addressbook
noblacklist ${HOME}/.alpine-smime
noblacklist ${HOME}/.mailcap
noblacklist ${HOME}/.mh_profile
noblacklist ${HOME}/.mime.types
noblacklist ${HOME}/.newsrc
noblacklist ${HOME}/.pine-crash
noblacklist ${HOME}/.pine-debug1
noblacklist ${HOME}/.pine-debug2
noblacklist ${HOME}/.pine-debug3
noblacklist ${HOME}/.pine-debug4
noblacklist ${HOME}/.pine-interrupted-mail
noblacklist ${HOME}/.pinerc
noblacklist ${HOME}/.pinercex
noblacklist ${HOME}/.signature
noblacklist ${HOME}/mail

blacklist ${RUNUSER}/wayland-*

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-programs.inc
include disable-shell.inc
include disable-x11.inc
include disable-xdg.inc

#whitelist ${DOCUMENTS}
#whitelist ${DOWNLOADS}
#whitelist ${HOME}/.addressbook
#whitelist ${HOME}/.alpine-smime
#whitelist ${HOME}/.mailcap
#whitelist ${HOME}/.mh_profile
#whitelist ${HOME}/.mime.types
#whitelist ${HOME}/.newsrc
#whitelist ${HOME}/.pine-crash
#whitelist ${HOME}/.pine-interrupted-mail
#whitelist ${HOME}/.pinerc
#whitelist ${HOME}/.pinercex
#whitelist ${HOME}/.pine-debug1
#whitelist ${HOME}/.pine-debug2
#whitelist ${HOME}/.pine-debug3
#whitelist ${HOME}/.pine-debug4
#whitelist ${HOME}/.signature
#whitelist ${HOME}/mail
whitelist /var/mail
whitelist /var/spool/mail
#include whitelist-common.inc
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
seccomp.block-secondary
tracelog

disable-mnt
private-bin alpine
private-cache
private-dev
private-etc @tls-ca,@x11,c-client.cf,host.conf,krb5.keytab,mailcap,mime.types,pine.conf,pinerc.fixed,rpc,services,terminfo
private-tmp
writable-run-user
writable-var

dbus-user none
dbus-system none

memory-deny-write-execute
read-only ${HOME}/.signature
restrict-namespaces

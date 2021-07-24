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

nodeny  /var/mail
nodeny  /var/spool/mail
nodeny  ${DOCUMENTS}
nodeny  ${HOME}/.addressbook
nodeny  ${HOME}/.alpine-smime
nodeny  ${HOME}/.mailcap
nodeny  ${HOME}/.mh_profile
nodeny  ${HOME}/.mime.types
nodeny  ${HOME}/.newsrc
nodeny  ${HOME}/.pine-crash
nodeny  ${HOME}/.pine-debug1
nodeny  ${HOME}/.pine-debug2
nodeny  ${HOME}/.pine-debug3
nodeny  ${HOME}/.pine-debug4
nodeny  ${HOME}/.pine-interrupted-mail
nodeny  ${HOME}/.pinerc
nodeny  ${HOME}/.pinercex
nodeny  ${HOME}/.signature
nodeny  ${HOME}/mail

deny  /tmp/.X11-unix
deny  ${RUNUSER}/wayland-*

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc
include disable-shell.inc
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
allow  /var/mail
allow  /var/spool/mail
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
shell none
tracelog

disable-mnt
private-bin alpine
private-cache
private-dev
private-etc alternatives,c-client.cf,ca-certificates,crypto-policies,host.conf,hostname,hosts,krb5.keytab,ld.so.cache,ld.so.conf,ld.so.conf.d,ld.so.preload,locale,locale.alias,locale.conf,localtime,mailcap,mime.types,nsswitch.conf,passwd,pine.conf,pinerc.fixed,pki,protocols,resolv.conf,rpc,services,ssl,terminfo,xdg
private-tmp
writable-run-user
writable-var

dbus-user none
dbus-system none

memory-deny-write-execute
read-only ${HOME}/.signature

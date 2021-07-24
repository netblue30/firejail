# Firejail profile for dino
# Description: Modern XMPP Chat Client using GTK+/Vala
# This file is overwritten after every install/update
# Persistent local customizations
include dino.local
# Persistent global definitions
include globals.local

nodeny  ${HOME}/.local/share/dino

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc
include disable-shell.inc

mkdir ${HOME}/.local/share/dino
allow  ${HOME}/.local/share/dino
allow  ${DOWNLOADS}
include whitelist-common.inc
include whitelist-runuser-common.inc
include whitelist-usr-share-common.inc
include whitelist-var-common.inc

caps.drop all
netfilter
nodvd
nogroups
noinput
nonewprivs
noroot
notv
nou2f
protocol unix,inet,inet6
seccomp
seccomp.block-secondary
shell none
tracelog

disable-mnt
private-bin dino
private-dev
# private-etc alternatives,ca-certificates,crypto-policies,fonts,pki,ssl -- breaks server connection
private-tmp

dbus-system none

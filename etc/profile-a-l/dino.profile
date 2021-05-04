# Firejail profile for dino
# Description: Modern XMPP Chat Client using GTK+/Vala
# This file is overwritten after every install/update
# Persistent local customizations
include dino.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.local/share/dino

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc
include disable-shell.inc

mkdir ${HOME}/.local/share/dino
whitelist ${HOME}/.local/share/dino
whitelist ${DOWNLOADS}
include whitelist-common.inc

caps.drop all
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

disable-mnt
private-bin dino
private-dev
# private-etc alternatives,ca-certificates,crypto-policies,fonts,pki,ssl -- breaks server connection
private-tmp


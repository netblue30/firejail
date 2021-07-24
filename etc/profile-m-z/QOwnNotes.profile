# Firejail profile for QOwnNotes
# Description: Plain-text file notepad with markdown support and ownCloud integration
# This file is overwritten after every install/update
# Persistent local customizations
include QOwnNotes.local
# Persistent global definitions
include globals.local

nodeny  ${DOCUMENTS}
nodeny  ${HOME}/Nextcloud/Notes
nodeny  ${HOME}/.config/PBE
nodeny  ${HOME}/.local/share/PBE

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc
include disable-shell.inc
include disable-xdg.inc

mkdir ${HOME}/Nextcloud/Notes
mkdir ${HOME}/.config/PBE
mkdir ${HOME}/.local/share/PBE
allow  ${DOCUMENTS}
allow  ${HOME}/Nextcloud/Notes
allow  ${HOME}/.config/PBE
allow  ${HOME}/.local/share/PBE
include whitelist-common.inc
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
protocol unix,inet,inet6,netlink
seccomp
shell none
tracelog

disable-mnt
private-bin gio,QOwnNotes
private-dev
private-etc alternatives,ca-certificates,crypto-policies,fonts,host.conf,hosts,ld.so.cache,machine-id,nsswitch.conf,pki,pulse,resolv.conf,ssl
private-tmp


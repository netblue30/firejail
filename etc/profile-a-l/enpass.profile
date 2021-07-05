# Firejail profile for enpass
# Description: A multiplatform password manager
# This file is overwritten after every install/update.
# Persistent local customisations
include enpass.local
# Persistent global definitions
include globals.local

nodeny  ${HOME}/.cache/Enpass
nodeny  ${HOME}/.config/sinew.in
nodeny  ${HOME}/.config/Sinew Software Systems
nodeny  ${HOME}/.local/share/Enpass
nodeny  ${DOCUMENTS}

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc
include disable-xdg.inc

mkdir ${HOME}/.cache/Enpass
mkfile ${HOME}/.config/sinew.in
mkdir ${HOME}/.config/Sinew Software Systems
mkdir ${HOME}/.local/share/Enpass
allow  ${HOME}/.cache/Enpass
allow  ${HOME}/.config/sinew.in
allow  ${HOME}/.config/Sinew Software Systems
allow  ${HOME}/.local/share/Enpass
allow  ${DOCUMENTS}
include whitelist-common.inc
include whitelist-var-common.inc

# machine-id and nosound break audio notification functionality.
# Add the next lines to your enpass.local if you need that functionality.
#ignore machine-id
#ignore nosound
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

private-bin dirname,Enpass,importer_enpass,readlink,sh
?HAS_APPIMAGE: ignore private-dev
private-dev
private-opt Enpass
private-tmp

#memory-deny-write-execute - breaks on Arch (see issue #1803)

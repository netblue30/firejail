# Firejail profile for enpass
# Description: A multiplatform password manager
# This file is overwritten after every install/update.
# Persistent local customisations
include enpass.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.cache/Enpass
noblacklist ${HOME}/.config/sinew.in
noblacklist ${HOME}/.config/Sinew Software Systems
noblacklist ${HOME}/.local/share/Enpass
noblacklist ${DOCUMENTS}

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
whitelist ${HOME}/.cache/Enpass
whitelist ${HOME}/.config/sinew.in
whitelist ${HOME}/.config/Sinew Software Systems
whitelist ${HOME}/.local/share/Enpass
whitelist ${DOCUMENTS}
include whitelist-common.inc
include whitelist-var-common.inc

# machine-id and nosound break audio notification functionality
# comment both if you need that functionality or put 'ignore machine-id'
# and 'ignore nosound' in your enpass.local

caps.drop all
machine-id
netfilter
no3d
nodvd
nogroups
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

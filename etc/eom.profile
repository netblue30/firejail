# Firejail profile for eom
# Description: Eye of MATE graphics viewer program
# This file is overwritten after every install/update
# Persistent local customizations
include eom.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.Steam
noblacklist ${HOME}/.config/mate/eom
noblacklist ${HOME}/.local/share/Trash
noblacklist ${HOME}/.steam

include disable-common.inc
include disable-devel.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc

include whitelist-var-common.inc

caps.drop all
no3d
nodvd
nogroups
nonewprivs
noroot
nosound
notv
nou2f
novideo
protocol unix
seccomp
shell none
tracelog

# private-bin, private-etc and private-lib break 'Open With' / 'Open in file manager'
# comment those if you need that functionality
private-bin eom
private-dev
private-etc alternatives,fonts
private-lib
private-tmp

#memory-deny-write-execute - breaks on Arch
noexec ${HOME}
noexec /tmp

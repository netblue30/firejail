# Firejail profile for transmission-qt
# Description: Fast, easy and free BitTorrent client (Qt GUI)
# This file is overwritten after every install/update
# Persistent local customizations
include transmission-qt.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.cache/transmission
noblacklist ${HOME}/.config/transmission

include disable-common.inc
include disable-devel.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc

mkdir ${HOME}/.cache/transmission
mkdir ${HOME}/.config/transmission
whitelist ${DOWNLOADS}
whitelist ${HOME}/.cache/transmission
whitelist ${HOME}/.config/transmission
include whitelist-common.inc
include whitelist-var-common.inc

apparmor
caps.drop all
machine-id
netfilter
nodbus
nodvd
nonewprivs
noroot
nosound
notv
nou2f
novideo
protocol unix,inet,inet6
seccomp
shell none
tracelog

private-bin transmission-qt
private-dev
# private-lib - problems on Arch
private-tmp

# memory-deny-write-execute - problems on Qt 5.10.0, KDE Frameworks 5.41.0
noexec ${HOME}
noexec /tmp

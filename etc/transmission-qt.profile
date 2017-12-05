# Firejail profile for transmission-qt
# This file is overwritten after every install/update
# Persistent local customizations
include /etc/firejail/transmission-qt.local
# Persistent global definitions
include /etc/firejail/globals.local

noblacklist ${HOME}/.cache/transmission
noblacklist ${HOME}/.config/transmission

include /etc/firejail/disable-common.inc
include /etc/firejail/disable-devel.inc
include /etc/firejail/disable-passwdmgr.inc
include /etc/firejail/disable-programs.inc

mkdir ${HOME}/.cache/transmission
mkdir ${HOME}/.config/transmission
whitelist  ${DOWNLOADS}
whitelist ${HOME}/.cache/transmission
whitelist ${HOME}/.config/transmission
include /etc/firejail/whitelist-common.inc
include /etc/firejail/whitelist-var-common.inc

caps.drop all
machine-id
netfilter
nodvd
nonewprivs
noroot
nosound
notv
novideo
protocol unix,inet,inet6
seccomp
shell none
tracelog

private-bin transmission-qt
private-dev
# private-lib - problems on Arch
private-tmp

memory-deny-write-execute

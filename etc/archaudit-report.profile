# Firejail profile for archaudit-report
# This file is overwritten after every install/update
quiet
# Persistent local customizations
include /etc/firejail/archaudit-report.local
# Persistent global definitions
include /etc/firejail/globals.local


noblacklist /var/lib/pacman

include /etc/firejail/disable-common.inc
include /etc/firejail/disable-devel.inc
include /etc/firejail/disable-passwdmgr.inc
include /etc/firejail/disable-programs.inc
include /etc/firejail/whitelist-common.inc

caps.drop all
ipc-namespace
netfilter
no3d
nodvd
nogroups
nonewprivs
noroot
nosound
notv
novideo
protocol unix,inet,inet6
seccomp
shell none

disable-mnt
private
private-bin archaudit-report,arch-audit,bash,cat,comm,cut,date,fold,grep,pacman,pactree,rm,sed,sort,whoneeds
#private-dev
private-tmp

memory-deny-write-execute
noexec ${HOME}
noexec /tmp

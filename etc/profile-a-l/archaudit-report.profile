# Firejail profile for archaudit-report
# This file is overwritten after every install/update
quiet
# Persistent local customizations
include archaudit-report.local
# Persistent global definitions
include globals.local

noblacklist /var/lib/pacman

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-programs.inc
include disable-xdg.inc

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

disable-mnt
private
private-bin arch-audit,archaudit-report,bash,cat,comm,cut,date,fold,grep,pacman,pactree,rm,sed,sort,whoneeds
#private-dev
private-tmp

memory-deny-write-execute
restrict-namespaces

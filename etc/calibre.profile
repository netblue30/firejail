# Firejail profile for calibre
# This file is overwritten after every install/update
# Persistent local customizations
include /etc/firejail/calibre.local
# Persistent global definitions
include /etc/firejail/globals.local

noblacklist ~/.cache/calibre
noblacklist ~/.config/calibre

include /etc/firejail/disable-common.inc
# include /etc/firejail/disable-devel.inc
include /etc/firejail/disable-passwdmgr.inc
include /etc/firejail/disable-programs.inc

caps.drop all
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
tracelog

# private-bin
private-dev
private-tmp

noexec ${HOME}
noexec /tmp

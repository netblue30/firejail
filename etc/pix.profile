# Firejail profile for pix
# This file is overwritten after every install/update
# Persistent local customizations
include /etc/firejail/pix.local
# Persistent global definitions
include /etc/firejail/globals.local

noblacklist ${HOME}/.config/pix
noblacklist ${HOME}/.local/share/pix
noblacklist ~/.Steam
noblacklist ~/.steam

include /etc/firejail/disable-common.inc
include /etc/firejail/disable-devel.inc
include /etc/firejail/disable-passwdmgr.inc
include /etc/firejail/disable-programs.inc

caps.drop all
nogroups
nonewprivs
noroot
nosound
protocol unix
seccomp
shell none
tracelog

private-bin pix
private-dev
private-tmp

# Firejail profile for transmission-show
# This file is overwritten after every install/update
# Persistent local customizations
include /etc/firejail/transmission-show.local
# Persistent global definitions
include /etc/firejail/globals.local

noblacklist ${HOME}/.cache/transmission
noblacklist ${HOME}/.config/transmission

include /etc/firejail/disable-common.inc
include /etc/firejail/disable-devel.inc
include /etc/firejail/disable-passwdmgr.inc
include /etc/firejail/disable-programs.inc

caps.drop all
net none
nonewprivs
noroot
nosound
notv
protocol unix
seccomp
shell none
tracelog

# private-bin
private-dev
private-etc none
private-tmp

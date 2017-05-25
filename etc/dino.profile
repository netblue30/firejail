# Persistent global definitions go here
include /etc/firejail/globals.local

# This file is overwritten during software install.
# Persistent customizations should go in a .local file.
include /etc/firejail/dino.local

# Firejail profile for Dino
noblacklist ${HOME}/.local/share/dino

include /etc/firejail/disable-common.inc
include /etc/firejail/disable-devel.inc
include /etc/firejail/disable-passwdmgr.inc
include /etc/firejail/disable-programs.inc

whitelist ${HOME}/Downloads
mkdir ${HOME}/.local/share/dino
whitelist ${HOME}/.local/share/dino
include /etc/firejail/whitelist-common.inc

caps.drop all
#ipc-namespace
netfilter
no3d
nogroups
nonewprivs
noroot
nosound
protocol unix,inet,inet6
seccomp
shell none

private-bin dino
#private-etc fonts #breaks server connection
private-dev
private-tmp

noexec ${HOME}
noexec /tmp

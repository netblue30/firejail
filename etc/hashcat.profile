# Firejail profile for hashcat
# This file is overwritten after every install/update
quiet
# Persistent local customizations
include /etc/firejail/hashcat.local
# Persistent global definitions
include /etc/firejail/globals.local

noblacklist ${HOME}/.hashcat
noblacklist /usr/include

include /etc/firejail/disable-common.inc
include /etc/firejail/disable-devel.inc
include /etc/firejail/disable-interpreters.inc
include /etc/firejail/disable-passwdmgr.inc
include /etc/firejail/disable-programs.inc

caps.drop all
net none
nodbus
nodvd
nogroups
nonewprivs
noroot
nosound
notv
novideo
protocol unix
seccomp
shell none

disable-mnt
private-bin hashcat
private-dev
private-tmp

noexec ${HOME}
noexec /tmp

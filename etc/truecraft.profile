# Persistent global definitions go here
include /etc/firejail/globals.local

# This file is overwritten during software install.
# Persistent customizations should go in a .local file.
include /etc/firejail/truecraft.local

# Firejail profile for TrueCraft
noblacklist ${HOME}/.config/mono
noblacklist ${HOME}/.config/truecraft

include /etc/firejail/disable-common.inc
include /etc/firejail/disable-devel.inc
include /etc/firejail/disable-passwdmgr.inc
include /etc/firejail/disable-programs.inc

mkdir ${HOME}/.config/mono
whitelist ${HOME}/.config/mono
mkdir ${HOME}/.config/truecraft
whitelist ${HOME}/.config/truecraft
include /etc/firejail/whitelist-common.inc

caps.drop all
nogroups
nonewprivs
noroot
novideo
protocol unix,inet,inet6
seccomp
shell none

disable-mnt
private-dev
private-tmp

noexec ${HOME}
noexec /tmp

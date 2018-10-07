# Firejail profile for truecraft
# This file is overwritten after every install/update
# Persistent local customizations
include /etc/firejail/truecraft.local
# Persistent global definitions
include /etc/firejail/globals.local

noblacklist ${HOME}/.config/mono
noblacklist ${HOME}/.config/truecraft

include /etc/firejail/disable-common.inc
include /etc/firejail/disable-devel.inc
include /etc/firejail/disable-interpreters.inc
include /etc/firejail/disable-passwdmgr.inc
include /etc/firejail/disable-programs.inc

mkdir ${HOME}/.config/mono
mkdir ${HOME}/.config/truecraft
whitelist ${HOME}/.config/mono
whitelist ${HOME}/.config/truecraft
include /etc/firejail/whitelist-common.inc

caps.drop all
nodvd
nogroups
nonewprivs
noroot
notv
novideo
protocol unix,inet,inet6
seccomp
shell none

disable-mnt
private-dev
private-tmp

noexec ${HOME}
noexec /tmp

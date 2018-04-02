# Firejail profile for psi-plus
# This file is overwritten after every install/update
# Persistent local customizations
include /etc/firejail/psi-plus.local
# Persistent global definitions
include /etc/firejail/globals.local

noblacklist ${HOME}/.config/psi+
noblacklist ${HOME}/.local/share/psi+

include /etc/firejail/disable-common.inc
include /etc/firejail/disable-devel.inc
include /etc/firejail/disable-interpreters.inc
include /etc/firejail/disable-passwdmgr.inc
include /etc/firejail/disable-programs.inc

mkdir ${HOME}/.cache/psi+
mkdir ${HOME}/.config/psi+
mkdir ${HOME}/.local/share/psi+
whitelist ${DOWNLOADS}
whitelist ${HOME}/.cache/psi+
whitelist ${HOME}/.config/psi+
whitelist ${HOME}/.local/share/psi+
include /etc/firejail/whitelist-common.inc

caps.drop all
netfilter
no3d
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

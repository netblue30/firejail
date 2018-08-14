# Firejail profile for liferea
# Description: Feed/news/podcast client with plugin support
# This file is overwritten after every install/update
# Persistent local customizations
include /etc/firejail/liferea.local
# Persistent global definitions
include /etc/firejail/globals.local

noblacklist ${HOME}/.cache/liferea
noblacklist ${HOME}/.config/liferea
noblacklist ${HOME}/.local/share/liferea

# Allow python (blacklisted by disable-interpreters.inc)
noblacklist ${PATH}/python2*
noblacklist ${PATH}/python3*
noblacklist /usr/lib/python2*
noblacklist /usr/lib/python3*

include /etc/firejail/disable-common.inc
include /etc/firejail/disable-devel.inc
include /etc/firejail/disable-interpreters.inc
include /etc/firejail/disable-passwdmgr.inc
include /etc/firejail/disable-programs.inc

mkdir ${HOME}/.cache/liferea
mkdir ${HOME}/.config/liferea
mkdir ${HOME}/.local/share/liferea
whitelist ${HOME}/.cache/liferea
whitelist ${HOME}/.config/liferea
whitelist ${HOME}/.local/share/liferea
include /etc/firejail/whitelist-common.inc

caps.drop all
netfilter
# no3d
nodvd
nogroups
nonewprivs
noroot
# nosound
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

# Firejail profile for gajim
# This file is overwritten after every install/update
# Persistent local customizations
include /etc/firejail/gajim.local
# Persistent global definitions
include /etc/firejail/globals.local

noblacklist ${HOME}/.cache/gajim
noblacklist ${HOME}/.config/gajim
noblacklist ${HOME}/.local/share/gajim

include /etc/firejail/disable-common.inc
include /etc/firejail/disable-devel.inc
include /etc/firejail/disable-passwdmgr.inc
include /etc/firejail/disable-programs.inc

mkdir ${HOME}/.cache/gajim
mkdir ${HOME}/.config/gajim
mkdir ${HOME}/.local/lib/python2.7/site-packages/
mkdir ${HOME}/.local/share/gajim
mkdir ${HOME}/Downloads
whitelist ${HOME}/.cache/gajim
whitelist ${HOME}/.config/gajim
whitelist ${HOME}/.local/lib/python2.7/site-packages/
whitelist ${HOME}/.local/share/gajim
whitelist ${HOME}/Downloads
include /etc/firejail/whitelist-common.inc

caps.drop all
netfilter
nodvd
nogroups
nonewprivs
noroot
notv
protocol unix,inet,inet6
seccomp
shell none

disable-mnt
# private-bin python2.7 gajim
private-dev
# private-etc fonts
# private-tmp
# Allow the local python 2.7 site packages, in case any plugins are using these
read-only ${HOME}/.local/lib/python2.7/site-packages/

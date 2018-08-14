# Firejail profile for 2048-qt
# Description: Mathematics based puzzle game
# This file is overwritten after every install/update
# Persistent local customizations
include /etc/firejail/2048-qt.local
# Persistent global definitions
include /etc/firejail/globals.local

noblacklist ${HOME}/.config/2048-qt
noblacklist ${HOME}/.config/xiaoyong

include /etc/firejail/disable-common.inc
include /etc/firejail/disable-devel.inc
include /etc/firejail/disable-interpreters.inc
include /etc/firejail/disable-passwdmgr.inc
include /etc/firejail/disable-programs.inc

mkdir ${HOME}/.config/2048-qt
mkdir ${HOME}/.config/xiaoyong
whitelist ${HOME}/.config/2048-qt
whitelist ${HOME}/.config/xiaoyong
include /etc/firejail/whitelist-common.inc
include /etc/firejail/whitelist-var-common.inc

caps.drop all
netfilter
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
private-dev
private-tmp

noexec ${HOME}
noexec /tmp

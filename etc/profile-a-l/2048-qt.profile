# Firejail profile for 2048-qt
# Description: Mathematics based puzzle game
# This file is overwritten after every install/update
# Persistent local customizations
include 2048-qt.local
# Persistent global definitions
include globals.local

nodeny  ${HOME}/.config/2048-qt
nodeny  ${HOME}/.config/xiaoyong

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc

mkdir ${HOME}/.config/2048-qt
mkdir ${HOME}/.config/xiaoyong
allow  ${HOME}/.config/2048-qt
allow  ${HOME}/.config/xiaoyong
include whitelist-common.inc
include whitelist-var-common.inc

apparmor
caps.drop all
net none
nodvd
nogroups
noinput
nonewprivs
noroot
nosound
notv
nou2f
novideo
protocol unix
seccomp
shell none

disable-mnt
private-dev
private-tmp

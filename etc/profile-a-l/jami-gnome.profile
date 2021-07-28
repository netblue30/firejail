# Firejail profile for jami-gnome
# Description: An encrypted peer-to-peer messenger
# This file is overwritten after every install/update
# Persistent local customizations
include jami-gnome.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.config/jami
noblacklist ${HOME}/.local/share/jami

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
#include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc

mkdir ${HOME}/.config/jami
mkdir ${HOME}/.local/share/jami
whitelist ${HOME}/.config/jami
whitelist ${HOME}/.local/share/jami
include whitelist-common.inc
include whitelist-var-common.inc

caps.drop all
ipc-namespace
netfilter
nodvd
nogroups
noinput
nonewprivs
noroot
notv
protocol unix,inet,inet6,netlink
seccomp
shell none

disable-mnt
private-dev
private-tmp

env QT_QPA_PLATFORM=xcb

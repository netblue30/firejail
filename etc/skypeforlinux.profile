# Firejail profile for skypeforlinux
# This file is overwritten after every install/update
# Persistent local customizations
include skypeforlinux.local
# Persistent global definitions
include globals.local

# breaks Skype
ignore noexec /tmp

noblacklist ${HOME}/.config/skypeforlinux

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc
include disable-xdg.inc

caps.keep sys_admin,sys_chroot
netfilter
nodvd
nogroups
notv
shell none

disable-mnt
private-cache
# private-dev - needs /dev/disk
private-tmp

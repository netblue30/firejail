# Firejail profile for signal-desktop
# This file is overwritten after every install/update
# Persistent local customizations
include signal-desktop.local
# Persistent global definitions
include globals.local

ignore noexec /tmp

noblacklist ${HOME}/.config/Signal

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-programs.inc
include disable-passwdmgr.inc

mkdir ${HOME}/.config/Signal
whitelist ${DOWNLOADS}
whitelist ${HOME}/.config/Signal
include whitelist-common.inc
include whitelist-var-common.inc

caps.keep sys_admin,sys_chroot
netfilter
nodvd
nogroups
notv
nou2f
shell none

disable-mnt
private-dev
private-tmp

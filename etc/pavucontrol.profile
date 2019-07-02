# Firejail profile for pavucontrol
# Description: PulseAudio Volume Control [GTK]
# This file is overwritten after every install/update
# Persistent local customizations
include pavucontrol.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.config/pavucontrol.ini

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc
include disable-xdg.inc

mkfile ${HOME}/.config/pavucontrol.ini
whitelist ${HOME}/.config/pavucontrol.ini
include whitelist-common.inc
include whitelist-var-common.inc

apparmor
caps.drop all
netfilter
no3d
nodbus
nodvd
nogroups
nonewprivs
noroot
notv
nou2f
novideo
protocol unix,inet,inet6
seccomp
shell none

disable-mnt
private-bin pavucontrol
private-cache
private-dev
private-etc alternatives,asound.conf,avahi,fonts,machine-id,pulse
private-lib
private-tmp

memory-deny-write-execute

# Firejail profile for pavucontrol
# Description: PulseAudio Volume Control [GTK]
# This file is overwritten after every install/update
# Persistent local customizations
include pavucontrol.local
# Persistent global definitions
include globals.local

nodeny  ${HOME}/.config/pavucontrol.ini

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc
include disable-xdg.inc

# whitelisting in ${HOME} is broken, see #3112
#mkfile ${HOME}/.config/pavucontrol.ini
#whitelist ${HOME}/.config/pavucontrol.ini
allow  /usr/share/pavucontrol
allow  /usr/share/pavucontrol-qt
#include whitelist-common.inc
include whitelist-usr-share-common.inc
include whitelist-var-common.inc

apparmor
caps.drop all
netfilter
no3d
nodvd
nogroups
noinput
nonewprivs
noroot
notv
nou2f
novideo
protocol unix,inet,inet6
seccomp
shell none
tracelog

disable-mnt
private-bin pavucontrol
private-cache
private-dev
private-etc alternatives,asound.conf,avahi,fonts,machine-id,pulse
private-lib
private-tmp

dbus-user none
dbus-system none

# mdwe is broken under Wayland, but works under Xorg.
#memory-deny-write-execute

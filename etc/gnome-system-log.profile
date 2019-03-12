# Firejail profile for gnome-system-log
# Description: View your system logs
# This file is overwritten after every install/update
# Persistent local customizations
include gnome-system-log.local
# Persistent global definitions
include globals.local

noblacklist /var/log

include disable-common.inc
include disable-devel.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc
include disable-xdg.inc

whitelist /var/log
include whitelist-common.inc
include whitelist-var-common.inc

apparmor
caps.drop all
ipc-namespace
# net none - breaks dbus
no3d
# nodbus
nodvd
# When using 'volatile' storage (https://www.freedesktop.org/software/systemd/man/journald.conf.html),
# comment both 'nogroups' and 'noroot'
nogroups
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
private-bin gnome-system-log
private-cache
private-dev
private-etc alternatives,fonts,localtime,machine-id
private-lib
private-tmp
writable-var-log

memory-deny-write-execute
noexec ${HOME}
noexec /tmp

# uncomment this if you never export logs to a file in your ${HOME}
#read-only ${HOME}

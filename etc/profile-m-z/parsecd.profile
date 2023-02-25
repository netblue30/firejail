# Firejail profile for Parsec
# Description: Remote desktop application focused on gaming and other 3D applications
# This file is overwritten after every install/update
# Persistent local customizations
include parsecd.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.parsec
ignore noexec ${HOME}

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-proc.inc
include disable-programs.inc
include disable-shell.inc
include disable-xdg.inc

mkdir ${HOME}/.parsec
whitelist ${HOME}/.parsec
whitelist /usr/share/parsec
include whitelist-common.inc
include whitelist-usr-share-common.inc
include whitelist-run-common.inc
include whitelist-runuser-common.inc
include whitelist-var-common.inc

# Due to the nature of parsec, the following directives will not work:
# - no3d
# - novideo
# - nosound
# - noinput (it does remote passthrough stuff for gamepads)
# - private-dev (because of the above)
apparmor
caps.drop all
nodvd
nogroups
nonewprivs
notv
nou2f
noroot
# Will fail to start with mty_evdev_create: 'udev_monitor_new_from_netlink' failed without netlink
protocol unix,inet,inet6,netlink
seccomp !tgkill
seccomp.block-secondary

# Will not start with zenity missing
private-bin parsecd,zenity
private-tmp

dbus-user none
dbus-system none

memory-deny-write-execute
restrict-namespaces

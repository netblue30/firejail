# Firejail profile for zed-editor
# Description: Zed-editor
# This file is overwritten after every install/update
include zed-editor.local
# Persistent global definitions
include globals.local

ignore noexec ${HOME}

noblacklist ${HOME}

# NOTE: add common development-related modifications, such as blacklisting,
# whitelisting, noexec, and other grants and permissions,
# to `~/.config/firejail/allow-common-devel.local`.
include allow-common-devel.inc

include disable-common.inc
include disable-exec.inc
include disable-proc.inc
include disable-programs.inc
#include disable-write-mnt.inc
include disable-xdg.inc

# TODO: consider landlock options.
# Landlock commands
##landlock.fs.read PATH
##landlock.fs.write PATH
##landlock.fs.makeipc PATH
##landlock.fs.makedev PATH
##landlock.fs.execute PATH
#include landlock-common.inc

# AppArmor causes issues with spawning sub-processes for language-tooling.
# This is probably only viable when used with a specialized profile for Zed.
#apparmor
caps.drop all
nodvd
nogroups
noinput
nonewprivs
noprinters
noroot
nosound
notv
nou2f
novideo
protocol unix,inet,inet6
#restrict-namespaces
seccomp
# For hardening: `seccomp.block-secondary`

disable-mnt
private-dev
private-tmp

# TODO: likely not complete.
dbus-user filter
dbus-user.talk org.freedesktop.portal.Desktop
dbus-user.talk org.a11y.Bus
# Add below line to `~/.config/firejail/zed-editor.local` to enable keyring-access.
#dbus-user.talk org.freedesktop.secrets
dbus-system none

deterministic-exit-code
deterministic-shutdown
noexec /tmp

# Firejail profile for zed-editor
# Description: Zed-editor
# This file is overwritten after every install/update
include zed-editor.local
# Persistent global definitions
include globals.local

ignore noexec ${HOME}

noblacklist ${HOME}

include allow-common-devel.inc

# NOTE: add `noblacklist` entries here or in `allow-common-devel.local` to allow
# for more programming languages and tools , such as `noblacklist ${HOME}/.cargo`.
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
protocol unix,inet,inet6,netlink
seccomp
# For hardening: `seccomp.block-secondary`

disable-mnt
private-dev
private-tmp

# TODO: likely not complete.
dbus-user filter
dbus-user.talk org.freedesktop.secrets
dbus-system none

deterministic-exit-code
deterministic-shutdown
noexec /tmp
restrict-namespaces

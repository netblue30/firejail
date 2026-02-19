# Profile for ./libexec/zed-editor
include zed-editor.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}
ignore noexec ${HOME}
include allow-common-devel.inc
# NOTE: add `noblacklist` entries here or in `allow-common-devel.local` to allow
# for more programming languages and tools , such as `noblacklist ${HOME}/.cargo`.

include disable-common.inc
#include disable-devel.inc
include disable-exec.inc
#include disable-interpreters.inc
include disable-programs.inc
include disable-xdg.inc
# TODO: probably want to exchange this for explicits and `disable-...` entries.
#include default.profile

novideo
nosound
noinput
nodvd
notv
nou2f
nogroups

disable-mnt
private-dev
private-tmp
noexec /tmp

# TODO: likely not complete.
dbus-user filter
dbus-user.talk org.freedesktop.secrets
dbus-system none

# AppArmor causes issues with spawning sub-processes for language-tooling.
# This is probably only viable when used with a specialized profile for Zed.
#apparmor
seccomp
# For hardening: `seccomp.block-secondary`
protocol unix,inet,inet6,netlink
restrict-namespaces
nonewprivs
caps.drop all
deterministic-exit-code
deterministic-shutdown


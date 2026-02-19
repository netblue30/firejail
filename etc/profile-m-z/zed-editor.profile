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
nodvd
notv
nou2f

disable-mnt
private-dev
private-tmp
noexec /tmp

# TODO: not tested, seen working.
dbus-user filter
dbus-system filter
#dbus-system.talk org.freedesktop.secrets

#apparmor
seccomp
# For hardening: `seccomp.block-secondary`
protocol unix,inet,inet6,netlink
restrict-namespaces
nonewprivs
caps.drop all
deterministic-exit-code
deterministic-shutdown


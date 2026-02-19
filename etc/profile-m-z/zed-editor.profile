# Profile for ./libexec/zed-editor
include zed-editor.local

noexec /tmp
noblacklist ${HOME}
include allow-common-devel.inc
# NOTE: add `noblacklist` entries here, such as `noblacklist ${HOME}/.cargo`, to
# support more programming languages and development tools.

# TODO: probably want to exchange this for explicits and `disable-...` entries.
include default.profile

novideo
nosound
nodvd
notv
nou2f

private-dev
private-tmp

# TODO: not tested, seen working.
dbus-user filter
dbus-system filter
dbus-system.talk org.freedesktop.secrets

seccomp
restrict-namespaces
caps.drop all
nonewprivs
deterministic-exit-code
deterministic-shutdown


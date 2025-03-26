# Firejail profile for audacity
# Description: Fast, cross-platform audio editor
# This file is overwritten after every install/update
# Persistent local customizations
include audacity.local
# Persistent global definitions
include globals.local

# To disable networking, add the following lines to audacity.local:
#ignore netfilter
#net none

noblacklist ${HOME}/.audacity-data
noblacklist ${HOME}/.cache/audacity
noblacklist ${HOME}/.config/audacity
noblacklist ${HOME}/.local/share/audacity
noblacklist ${HOME}/.local/state/audacity
noblacklist ${DOCUMENTS}
noblacklist ${MUSIC}

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-programs.inc
include disable-shell.inc
include disable-xdg.inc

include whitelist-var-common.inc

# Silence blacklist violation. See #5539.
allow-debuggers

## Enabling App Armor appears to break some Fedora / Arch installs
#apparmor
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
tracelog

private-bin audacity
private-dev
private-etc @network,@sound,@tls-ca,@x11
private-tmp

# problems on Fedora 27
#dbus-user none
#dbus-system none

restrict-namespaces

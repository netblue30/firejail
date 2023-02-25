# Firejail profile for kodi
# Description: Open Source Home Theatre
# This file is overwritten after every install/update
# Persistent local customizations
include kodi.local
# Persistent global definitions
include globals.local

# noexec ${HOME} breaks plugins
ignore noexec ${HOME}
# Add the following to your kodi.local if you use a CEC Adapter.
#ignore nogroups
#ignore noroot
#ignore private-dev
# Add the following to your kodi.local if you use the Lutris Kodi Addon
#noblacklist /sbin
#noblacklist /usr/sbin
#noblacklist ${HOME}/.cache/lutris
#noblacklist ${HOME}/.config/lutris
#noblacklist ${HOME}/.local/share/lutris

noblacklist ${HOME}/.kodi
noblacklist ${MUSIC}
noblacklist ${PICTURES}
noblacklist ${VIDEOS}

# Allow python (blacklisted by disable-interpreters.inc)
include allow-python2.inc
include allow-python3.inc

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-programs.inc
include disable-xdg.inc

include whitelist-var-common.inc

apparmor
caps.drop all
netfilter
nogroups
noinput
nonewprivs
noroot
nou2f
protocol unix,inet,inet6,netlink
seccomp
tracelog

private-dev
private-tmp

restrict-namespaces

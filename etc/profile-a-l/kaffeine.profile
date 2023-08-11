# Firejail profile for kaffeine
# Description: Versatile media player for KDE
# This file is overwritten after every install/update
# Persistent local customizations
include kaffeine.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.config/kaffeinerc
noblacklist ${HOME}/.kde/share/apps/kaffeine
noblacklist ${HOME}/.kde/share/config/kaffeinerc
noblacklist ${HOME}/.kde4/share/apps/kaffeine
noblacklist ${HOME}/.kde4/share/config/kaffeinerc
noblacklist ${HOME}/.local/share/kaffeine
noblacklist ${MUSIC}
noblacklist ${VIDEOS}

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-programs.inc
include disable-xdg.inc

include whitelist-run-common.inc
include whitelist-var-common.inc

caps.drop all
netfilter
nogroups
noinput
nonewprivs
noroot
nou2f
novideo
protocol unix,inet,inet6
seccomp

#private-bin kaffeine
private-dev
private-tmp

restrict-namespaces

# Firejail profile for kaffeine
# Description: Versatile media player for KDE
# This file is overwritten after every install/update
# Persistent local customizations
include /etc/firejail/kaffeine.local
# Persistent global definitions
include /etc/firejail/globals.local

noblacklist ${HOME}/.config/kaffeinerc
noblacklist ${HOME}/.kde/share/apps/kaffeine
noblacklist ${HOME}/.kde/share/config/kaffeinerc
noblacklist ${HOME}/.kde4/share/apps/kaffeine
noblacklist ${HOME}/.kde4/share/config/kaffeinerc
noblacklist ${HOME}/.local/share/kaffeine
noblacklist ${MUSIC}
noblacklist ${VIDEOS}

include /etc/firejail/disable-common.inc
include /etc/firejail/disable-devel.inc
include /etc/firejail/disable-interpreters.inc
include /etc/firejail/disable-passwdmgr.inc
include /etc/firejail/disable-programs.inc
include /etc/firejail/disable-xdg.inc

include /etc/firejail/whitelist-var-common.inc

caps.drop all
netfilter
nogroups
nonewprivs
noroot
novideo
protocol unix,inet,inet6
seccomp
shell none

# private-bin kaffeine
private-dev
private-tmp

noexec ${HOME}
noexec /tmp

# Firejail profile for kaffeine
# Description: Versatile media player for KDE
# This file is overwritten after every install/update
# Persistent local customizations
include kaffeine.local
# Persistent global definitions
include globals.local

nodeny  ${HOME}/.config/kaffeinerc
nodeny  ${HOME}/.kde/share/apps/kaffeine
nodeny  ${HOME}/.kde/share/config/kaffeinerc
nodeny  ${HOME}/.kde4/share/apps/kaffeine
nodeny  ${HOME}/.kde4/share/config/kaffeinerc
nodeny  ${HOME}/.local/share/kaffeine
nodeny  ${MUSIC}
nodeny  ${VIDEOS}

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc
include disable-xdg.inc

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
shell none

# private-bin kaffeine
private-dev
private-tmp


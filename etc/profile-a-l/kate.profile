# Firejail profile for kate
# Description: Powerful text editor
# This file is overwritten after every install/update
# Persistent local customizations
include kate.local
# Persistent global definitions
include globals.local

ignore noexec ${HOME}

noblacklist ${HOME}/.config/katemetainfos
noblacklist ${HOME}/.config/katepartrc
noblacklist ${HOME}/.config/katerc
noblacklist ${HOME}/.config/kateschemarc
noblacklist ${HOME}/.config/katesyntaxhighlightingrc
noblacklist ${HOME}/.config/katevirc
noblacklist ${HOME}/.config/kwinrc
noblacklist ${HOME}/.local/share/kate
noblacklist ${HOME}/.local/share/kxmlgui5/kate
noblacklist ${HOME}/.local/share/kxmlgui5/katefiletree
noblacklist ${HOME}/.local/share/kxmlgui5/katekonsole
noblacklist ${HOME}/.local/share/kxmlgui5/kateopenheaderplugin
noblacklist ${HOME}/.local/share/kxmlgui5/katepart
noblacklist ${HOME}/.local/share/kxmlgui5/kateproject
noblacklist ${HOME}/.local/share/kxmlgui5/katesearch

# Allows files commonly used by IDEs
include allow-common-devel.inc

include disable-common.inc
#include disable-devel.inc
include disable-exec.inc
#include disable-interpreters.inc
include disable-programs.inc

include whitelist-run-common.inc
include whitelist-var-common.inc

#apparmor
caps.drop all
#net none
netfilter
nodvd
nogroups
noinput
nonewprivs
noroot
nosound
notv
nou2f
novideo
protocol unix
seccomp

#private-bin kate,kbuildsycoca4,kdeinit4
private-dev
#private-etc alternatives,fonts,kde4rc,kde5rc,ld.so.cache,machine-id,xdg
private-tmp

#dbus-user none
#dbus-system none

restrict-namespaces
join-or-start kate

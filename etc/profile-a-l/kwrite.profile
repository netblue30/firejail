# Firejail profile for kwrite
# Description: Simple text editor
# This file is overwritten after every install/update
# Persistent local customizations
include kwrite.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.config/katepartrc
noblacklist ${HOME}/.config/katerc
noblacklist ${HOME}/.config/kateschemarc
noblacklist ${HOME}/.config/katesyntaxhighlightingrc
noblacklist ${HOME}/.config/katevirc
noblacklist ${HOME}/.config/kwriterc
noblacklist ${HOME}/.local/share/kwrite
noblacklist ${HOME}/.local/share/kxmlgui5/kwrite
noblacklist ${DOCUMENTS}

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-programs.inc
include disable-shell.inc
include disable-xdg.inc

include whitelist-run-common.inc
include whitelist-var-common.inc

apparmor
caps.drop all
#net none
netfilter
nodvd
nogroups
noinput
nonewprivs
noroot
#nosound # KWrite is using ALSA!
notv
nou2f
novideo
protocol unix
seccomp
tracelog

private-bin kbuildsycoca4,kdeinit4,kwrite
private-dev
private-etc @x11
private-tmp

#dbus-user none
#dbus-system none

restrict-namespaces
join-or-start kwrite

# Firejail profile for kwrite
# Description: Simple text editor
# This file is overwritten after every install/update
# Persistent local customizations
include kwrite.local
# Persistent global definitions
include globals.local

nodeny  ${HOME}/.config/katepartrc
nodeny  ${HOME}/.config/katerc
nodeny  ${HOME}/.config/kateschemarc
nodeny  ${HOME}/.config/katesyntaxhighlightingrc
nodeny  ${HOME}/.config/katevirc
nodeny  ${HOME}/.config/kwriterc
nodeny  ${HOME}/.local/share/kwrite
nodeny  ${HOME}/.local/share/kxmlgui5/kwrite
nodeny  ${DOCUMENTS}

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc
include disable-shell.inc
include disable-xdg.inc

include whitelist-var-common.inc

apparmor
caps.drop all
# net none
netfilter
nodvd
nogroups
noinput
nonewprivs
noroot
# nosound - KWrite is using ALSA!
notv
nou2f
novideo
protocol unix
seccomp
shell none
tracelog

private-bin kbuildsycoca4,kdeinit4,kwrite
private-dev
private-etc alternatives,fonts,kde4rc,kde5rc,ld.so.cache,machine-id,pulse,xdg
private-tmp

# dbus-user none
# dbus-system none

join-or-start kwrite

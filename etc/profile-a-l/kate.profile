# Firejail profile for kate
# Description: Powerful text editor
# This file is overwritten after every install/update
# Persistent local customizations
include kate.local
# Persistent global definitions
include globals.local

ignore noexec ${HOME}

nodeny  ${HOME}/.config/katemetainfos
nodeny  ${HOME}/.config/katepartrc
nodeny  ${HOME}/.config/katerc
nodeny  ${HOME}/.config/kateschemarc
nodeny  ${HOME}/.config/katesyntaxhighlightingrc
nodeny  ${HOME}/.config/katevirc
nodeny  ${HOME}/.local/share/kate
nodeny  ${HOME}/.local/share/kxmlgui5/kate
nodeny  ${HOME}/.local/share/kxmlgui5/katefiletree
nodeny  ${HOME}/.local/share/kxmlgui5/katekonsole
nodeny  ${HOME}/.local/share/kxmlgui5/kateopenheaderplugin
nodeny  ${HOME}/.local/share/kxmlgui5/katepart
nodeny  ${HOME}/.local/share/kxmlgui5/kateproject
nodeny  ${HOME}/.local/share/kxmlgui5/katesearch

include disable-common.inc
# include disable-devel.inc
include disable-exec.inc
# include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc

include whitelist-var-common.inc

# apparmor
caps.drop all
# net none
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
shell none
tracelog

# private-bin kate,kbuildsycoca4,kdeinit4
private-dev
# private-etc alternatives,fonts,kde4rc,kde5rc,ld.so.cache,machine-id,xdg
private-tmp

# dbus-user none
# dbus-system none

join-or-start kate

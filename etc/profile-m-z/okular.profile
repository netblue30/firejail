# Firejail profile for okular
# Description: Universal document viewer
# This file is overwritten after every install/update
# Persistent local customizations
include okular.local
# Persistent global definitions
include globals.local

nodeny  ${HOME}/.cache/okular
nodeny  ${HOME}/.config/okularpartrc
nodeny  ${HOME}/.config/okularrc
nodeny  ${HOME}/.kde/share/apps/okular
nodeny  ${HOME}/.kde/share/config/okularpartrc
nodeny  ${HOME}/.kde/share/config/okularrc
nodeny  ${HOME}/.kde4/share/apps/okular
nodeny  ${HOME}/.kde4/share/config/okularpartrc
nodeny  ${HOME}/.kde4/share/config/okularrc
nodeny  ${HOME}/.local/share/kxmlgui5/okular
nodeny  ${HOME}/.local/share/okular
nodeny  ${DOCUMENTS}

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc
include disable-shell.inc
include disable-xdg.inc

allow  /usr/share/config.kcfg/gssettings.kcfg
allow  /usr/share/config.kcfg/pdfsettings.kcfg
allow  /usr/share/config.kcfg/okular.kcfg
allow  /usr/share/config.kcfg/okular_core.kcfg
allow  /usr/share/ghostscript
allow  /usr/share/kconf_update/okular.upd
allow  /usr/share/kxmlgui5/okular
allow  /usr/share/okular
allow  /usr/share/poppler
include whitelist-runuser-common.inc
include whitelist-usr-share-common.inc
include whitelist-var-common.inc

apparmor
caps.drop all
machine-id
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

private-bin kbuildsycoca4,kdeinit4,lpr,okular,unar,unrar
private-dev
private-etc alternatives,cups,fonts,kde4rc,kde5rc,ld.so.cache,machine-id,passwd,xdg
# private-tmp - on KDE we need access to the real /tmp for data exchange with email clients

# dbus-user none
# dbus-system none

# memory-deny-write-execute

join-or-start okular

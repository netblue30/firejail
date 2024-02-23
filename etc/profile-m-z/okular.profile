# Firejail profile for okular
# Description: Universal document viewer
# This file is overwritten after every install/update
# Persistent local customizations
include okular.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.cache/okular
noblacklist ${HOME}/.config/okularpartrc
noblacklist ${HOME}/.config/okularrc
noblacklist ${HOME}/.kde/share/apps/okular
noblacklist ${HOME}/.kde/share/config/okularpartrc
noblacklist ${HOME}/.kde/share/config/okularrc
noblacklist ${HOME}/.kde4/share/apps/okular
noblacklist ${HOME}/.kde4/share/config/okularpartrc
noblacklist ${HOME}/.kde4/share/config/okularrc
noblacklist ${HOME}/.local/share/kxmlgui5/okular
noblacklist ${HOME}/.local/share/okular
noblacklist ${DOCUMENTS}

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-programs.inc
include disable-shell.inc
include disable-xdg.inc

whitelist /usr/share/config.kcfg/gssettings.kcfg
whitelist /usr/share/config.kcfg/pdfsettings.kcfg
whitelist /usr/share/config.kcfg/okular.kcfg
whitelist /usr/share/config.kcfg/okular_core.kcfg
whitelist /usr/share/ghostscript
whitelist /usr/share/kconf_update/okular.upd
whitelist /usr/share/okular
whitelist /usr/share/poppler
include whitelist-run-common.inc
include whitelist-runuser-common.inc
include whitelist-usr-share-common.inc
include whitelist-var-common.inc

apparmor
caps.drop all
machine-id
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
tracelog

private-bin kbuildsycoca4,kdeinit4,lpr,okular,unar,unrar
private-dev
private-etc @x11,cups
# on KDE we need access to the real /tmp for data exchange with email clients
#private-tmp

#dbus-user none
#dbus-system none

#memory-deny-write-execute

restrict-namespaces
join-or-start okular

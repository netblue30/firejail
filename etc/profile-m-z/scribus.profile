# Firejail profile for scribus
# Description: Open Source Desktop Page Layout
# This file is overwritten after every install/update
# Persistent local customizations
include scribus.local
# Persistent global definitions
include globals.local

# Support for PDF readers comes with Scribus 1.5 and higher
nodeny  ${HOME}/.cache/okular
nodeny  ${HOME}/.config/GIMP
nodeny  ${HOME}/.config/okularpartrc
nodeny  ${HOME}/.config/okularrc
nodeny  ${HOME}/.config/scribus
nodeny  ${HOME}/.config/scribusrc
nodeny  ${HOME}/.gimp*
nodeny  ${HOME}/.kde/share/apps/okular
nodeny  ${HOME}/.kde/share/config/okularpartrc
nodeny  ${HOME}/.kde/share/config/okularrc
nodeny  ${HOME}/.kde4/share/apps/okular
nodeny  ${HOME}/.kde4/share/config/okularpartrc
nodeny  ${HOME}/.kde4/share/config/okularrc
nodeny  ${HOME}/.local/share/okular
nodeny  ${HOME}/.local/share/scribus
nodeny  ${HOME}/.scribus
nodeny  ${DOCUMENTS}
nodeny  ${PICTURES}

# Allow python (blacklisted by disable-interpreters.inc)
include allow-python2.inc
include allow-python3.inc

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc
include disable-xdg.inc

include whitelist-var-common.inc

apparmor
caps.drop all
net none
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

# private-bin gimp*,gs,scribus
private-dev
private-tmp

dbus-user none
dbus-system none

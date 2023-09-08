# Firejail profile for scribus
# Description: Open Source Desktop Page Layout
# This file is overwritten after every install/update
# Persistent local customizations
include scribus.local
# Persistent global definitions
include globals.local

# Support for PDF readers comes with Scribus 1.5 and higher
noblacklist ${HOME}/.cache/okular
noblacklist ${HOME}/.config/GIMP
noblacklist ${HOME}/.config/okularpartrc
noblacklist ${HOME}/.config/okularrc
noblacklist ${HOME}/.config/scribus
noblacklist ${HOME}/.config/scribusrc
noblacklist ${HOME}/.gimp*
noblacklist ${HOME}/.kde/share/apps/okular
noblacklist ${HOME}/.kde/share/config/okularpartrc
noblacklist ${HOME}/.kde/share/config/okularrc
noblacklist ${HOME}/.kde4/share/apps/okular
noblacklist ${HOME}/.kde4/share/config/okularpartrc
noblacklist ${HOME}/.kde4/share/config/okularrc
noblacklist ${HOME}/.local/share/okular
noblacklist ${HOME}/.local/share/scribus
noblacklist ${HOME}/.scribus
noblacklist ${DOCUMENTS}
noblacklist ${PICTURES}

# Allow python (blacklisted by disable-interpreters.inc)
include allow-python2.inc
include allow-python3.inc

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
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
tracelog

#private-bin gimp*,gs,scribus
private-dev
private-tmp

dbus-user none
dbus-system none

restrict-namespaces

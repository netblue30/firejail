# Firejail profile for scribus
# Description: Open Source Desktop Page Layout
# This file is overwritten after every install/update
# Persistent local customizations
include /etc/firejail/scribus.local
# Persistent global definitions
include /etc/firejail/globals.local

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
noblacklist ${PATH}/python2*
noblacklist ${PATH}/python3*
noblacklist /usr/lib/python2*
noblacklist /usr/lib/python3*

include /etc/firejail/disable-common.inc
include /etc/firejail/disable-devel.inc
include /etc/firejail/disable-interpreters.inc
include /etc/firejail/disable-passwdmgr.inc
include /etc/firejail/disable-programs.inc
include /etc/firejail/disable-xdg.inc

include /etc/firejail/whitelist-var-common.inc

caps.drop all
net none
nodbus
nodvd
nogroups
nonewprivs
noroot
nosound
notv
novideo
protocol unix
seccomp
shell none
tracelog

# private-bin scribus,gs,gimp*
private-dev
private-tmp

noexec ${HOME}
noexec /tmp

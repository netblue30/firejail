# Firejail profile for digikam
# Description: Digital photo management application for KDE
# This file is overwritten after every install/update
# Persistent local customizations
include digikam.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.config/digikam
noblacklist ${HOME}/.config/digikamrc
noblacklist ${HOME}/.kde/share/apps/digikam
noblacklist ${HOME}/.kde4/share/apps/digikam
noblacklist ${HOME}/.local/share/kxmlgui5/digikam
noblacklist ${PICTURES}

# Allow perl (blacklisted by disable-interpreters.inc)
include allow-perl.inc

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-programs.inc
include disable-xdg.inc

include whitelist-var-common.inc

apparmor
caps.drop all
netfilter
nodvd
nogroups
nonewprivs
noroot
notv
protocol unix,inet,inet6,netlink
# QtWebengine needs chroot to set up its own sandbox
seccomp !chroot

# private-dev prevents libdc1394 from loading; this lib is used to connect to a
# camera device
#private-dev
#private-etc alternatives,ca-certificates,crypto-policies,pki,ssl
private-tmp

#dbus-user none
#dbus-system none

#restrict-namespaces

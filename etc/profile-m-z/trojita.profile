# Firejail profile for trojita
# Description: Qt mail client
# This file is overwritten after every install/update
# Persistent local customizations
include trojita.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.abook
noblacklist ${HOME}/.cache/flaska.net/trojita
noblacklist ${HOME}/.config/flaska.net

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-programs.inc
include disable-shell.inc
include disable-xdg.inc

# The lines below are needed to find the default Firefox profile name, to allow
# opening links in an existing instance of Firefox (note that it still fails if
# there isn't a Firefox instance running with the default profile; see #5352)
noblacklist ${HOME}/.mozilla
whitelist ${HOME}/.mozilla/firefox/profiles.ini

mkdir ${HOME}/.abook
mkdir ${HOME}/.cache/flaska.net/trojita
mkdir ${HOME}/.config/flaska.net
whitelist ${HOME}/.abook
whitelist ${HOME}/.cache/flaska.net/trojita
whitelist ${HOME}/.config/flaska.net
include whitelist-common.inc
include whitelist-runuser-common.inc
include whitelist-usr-share-common.inc
include whitelist-var-common.inc

apparmor
caps.drop all
netfilter
no3d
nodvd
nogroups
noinput
nonewprivs
noroot
nosound
notv
nou2f
novideo
protocol unix,inet,inet6,netlink
seccomp
tracelog

#disable-mnt
private-bin trojita
private-cache
private-dev
private-etc @tls-ca,@x11
private-tmp

dbus-user filter
dbus-user.talk org.freedesktop.secrets
# allow D-Bus communication with firefox for opening links
dbus-user.talk org.mozilla.*
dbus-system none

restrict-namespaces

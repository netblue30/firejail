# Firejail profile for gjs
# Description: Mozilla-based javascript bindings for the GNOME platform
# This file is overwritten after every install/update
# Persistent local customizations
include gjs.local
# Persistent global definitions
include globals.local

# when gjs apps are started via gnome-shell, firejail is not applied because systemd will start them

noblacklist ${HOME}/.cache/libgweather
noblacklist ${HOME}/.cache/org.gnome.Books
noblacklist ${HOME}/.config/libreoffice
noblacklist ${HOME}/.local/share/gnome-photos

# Allow gjs (blacklisted by disable-interpreters.inc)
include allow-gjs.inc

include disable-common.inc
include disable-devel.inc
include disable-interpreters.inc
include disable-programs.inc

include whitelist-runuser-common.inc
include whitelist-usr-share-common.inc
include whitelist-var-common.inc

caps.drop all
netfilter
nodvd
nogroups
noinput
nonewprivs
noroot
notv
nou2f
protocol unix,inet,inet6
seccomp
tracelog

#private-bin gjs,gnome-books,gnome-documents,gnome-maps,gnome-photos,gnome-weather
private-dev
#private-etc alternatives,ca-certificates,crypto-policies,fonts,pki,ssl
private-tmp

restrict-namespaces

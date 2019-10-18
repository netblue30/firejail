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

include disable-common.inc
include disable-devel.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc

include whitelist-usr-share-common.inc

caps.drop all
netfilter
nodvd
nogroups
nonewprivs
noroot
notv
nou2f
protocol unix,inet,inet6
seccomp
shell none
tracelog

# private-bin gjs,gnome-books,gnome-documents,gnome-maps,gnome-photos,gnome-weather
private-dev
# private-etc alternatives,ca-certificates,crypto-policies,fonts,pki,ssl
private-tmp

# Firejail profile for gnome-recipes
# Description: Recipe application for GNOME
# This file is overwritten after every install/update
# Persistent local customizations
include gnome-recipes.local
# Persistent global definitions
include globals.local


noblacklist ${HOME}/.cache/gnome-recipes
noblacklist ${HOME}/.local/share/gnome-recipes

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-programs.inc
include disable-shell.inc

mkdir ${HOME}/.cache/gnome-recipes
mkdir ${HOME}/.local/share/gnome-recipes
whitelist ${HOME}/.cache/gnome-recipes
whitelist ${HOME}/.local/share/gnome-recipes
whitelist /usr/share/gnome-recipes
include whitelist-common.inc
include whitelist-usr-share-common.inc
include whitelist-var-common.inc

apparmor
caps.drop all
ipc-namespace
machine-id
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
protocol unix,inet,inet6
seccomp

disable-mnt
private-bin gnome-recipes,tar
private-dev
private-etc alternatives,ca-certificates,crypto-policies,fonts,ld.so.cache,ld.so.preload,pki,ssl
private-lib gdk-pixbuf-2.0,gio,gvfs/libgvfscommon.so,libgconf-2.so.*,libgnutls.so.*,libjpeg.so.*,libp11-kit.so.*,libproxy.so.*,librsvg-2.so.*
private-tmp


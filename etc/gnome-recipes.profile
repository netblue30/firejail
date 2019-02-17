# Firejail profile for gnome-recipes
# Description: Recipe application for GNOME
# This file is overwritten after every install/update
# Persistent local customizations
include gnome-recipes.local
# Persistent global definitions
include globals.local


noblacklist ${HOME}/.local/share/gnome-recipes

include disable-common.inc
include disable-devel.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc

mkdir ${HOME}/.cache/gnome-recipes
whitelist ${HOME}/.cache/gnome-recipes
include whitelist-common.inc
include whitelist-var-common.inc

caps.drop all
ipc-namespace
netfilter
nodvd
nogroups
nonewprivs
noroot
nosound
notv
nou2f
novideo
protocol unix,inet,inet6
seccomp
shell none

disable-mnt
private-bin gnome-recipes,tar
private-dev
private-etc alternatives,ca-certificates,fonts,ssl,crypto-policies,pki
# private-lib works for me with Gnome Shell 3.26.2, Mutter WM (Arch Linux)
# not widely tested though, leaving it to devs discretion to enable it later
#private-lib gdk-pixbuf-2.0,gio,gvfs/libgvfscommon.so,libgconf-2.so.4,libgnutls.so.30,libjpeg.so.8,libp11-kit.so.0,libproxy.so.1,librsvg-2.so.2
private-tmp

noexec ${HOME}
noexec /tmp

# Firejail profile for midori
# Description: Lightweight web browser
# This file is overwritten after every install/update
# Persistent local customizations
include midori.local
# Persistent global definitions
include globals.local

# noexec ${HOME} breaks DRM binaries.
?BROWSER_ALLOW_DRM: ignore noexec ${HOME}

nodeny  ${HOME}/.cache/midori
nodeny  ${HOME}/.config/midori
nodeny  ${HOME}/.local/share/midori
# noblacklist ${HOME}/.local/share/webkit
# noblacklist ${HOME}/.local/share/webkitgtk
nodeny  ${HOME}/.pki
nodeny  ${HOME}/.local/share/pki

nodeny  ${HOME}/.cache/gnome-mplayer
nodeny  ${HOME}/.config/gnome-mplayer
nodeny  ${HOME}/.lastpass

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
#include disable-passwdmgr.inc
include disable-programs.inc
include disable-xdg.inc

mkdir ${HOME}/.cache/midori
mkdir ${HOME}/.config/midori
mkdir ${HOME}/.local/share/midori
mkdir ${HOME}/.local/share/webkit
mkdir ${HOME}/.local/share/webkitgtk
mkdir ${HOME}/.pki
mkdir ${HOME}/.local/share/pki
allow  ${DOWNLOADS}
allow  ${HOME}/.cache/gnome-mplayer/plugin
allow  ${HOME}/.cache/midori
allow  ${HOME}/.config/gnome-mplayer
allow  ${HOME}/.config/midori
allow  ${HOME}/.lastpass
allow  ${HOME}/.local/share/midori
allow  ${HOME}/.local/share/webkit
allow  ${HOME}/.local/share/webkitgtk
allow  ${HOME}/.pki
allow  ${HOME}/.local/share/pki
include whitelist-common.inc
include whitelist-var-common.inc

apparmor
caps.drop all
netfilter
nodvd
nonewprivs
# noroot - problems on Ubuntu 14.04
notv
protocol unix,inet,inet6,netlink
seccomp
tracelog

disable-mnt
private-tmp

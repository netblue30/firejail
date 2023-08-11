# Firejail profile for midori
# Description: Lightweight web browser
# This file is overwritten after every install/update
# Persistent local customizations
include midori.local
# Persistent global definitions
include globals.local

# noexec ${HOME} breaks DRM binaries.
?BROWSER_ALLOW_DRM: ignore noexec ${HOME}

noblacklist ${HOME}/.cache/midori
noblacklist ${HOME}/.config/midori
noblacklist ${HOME}/.local/share/midori
noblacklist ${HOME}/.local/share/pki
#noblacklist ${HOME}/.local/share/webkit
#noblacklist ${HOME}/.local/share/webkitgtk
noblacklist ${HOME}/.pki

noblacklist ${HOME}/.cache/gnome-mplayer
noblacklist ${HOME}/.config/gnome-mplayer
noblacklist ${HOME}/.lastpass

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-programs.inc
include disable-xdg.inc

mkdir ${HOME}/.cache/midori
mkdir ${HOME}/.config/midori
mkdir ${HOME}/.local/share/midori
mkdir ${HOME}/.local/share/pki
mkdir ${HOME}/.local/share/webkit
mkdir ${HOME}/.local/share/webkitgtk
mkdir ${HOME}/.pki
whitelist ${DOWNLOADS}
whitelist ${HOME}/.cache/gnome-mplayer/plugin
whitelist ${HOME}/.cache/midori
whitelist ${HOME}/.config/gnome-mplayer
whitelist ${HOME}/.config/midori
whitelist ${HOME}/.lastpass
whitelist ${HOME}/.local/share/midori
whitelist ${HOME}/.local/share/pki
whitelist ${HOME}/.local/share/webkit
whitelist ${HOME}/.local/share/webkitgtk
whitelist ${HOME}/.pki
include whitelist-common.inc
include whitelist-var-common.inc

apparmor
caps.drop all
netfilter
nodvd
nonewprivs
#noroot # problems on Ubuntu 14.04
notv
protocol unix,inet,inet6,netlink
seccomp
tracelog

disable-mnt
private-tmp

restrict-namespaces

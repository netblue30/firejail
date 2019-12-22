# Firejail profile for qutebrowser
# Description: Keyboard-driven, vim-like browser based on PyQt5
# This file is overwritten after every install/update
# Persistent local customizations
include qutebrowser.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.cache/qutebrowser
noblacklist ${HOME}/.config/qutebrowser
noblacklist ${HOME}/.local/share/qutebrowser

# Allow python (blacklisted by disable-interpreters.inc)
include allow-python2.inc
include allow-python3.inc

include disable-common.inc
include disable-devel.inc
include disable-interpreters.inc
include disable-programs.inc

mkdir ${HOME}/.cache/qutebrowser
mkdir ${HOME}/.config/qutebrowser
mkdir ${HOME}/.local/share/qutebrowser
whitelist ${DOWNLOADS}
whitelist ${HOME}/.cache/qutebrowser
whitelist ${HOME}/.config/qutebrowser
whitelist ${HOME}/.local/share/qutebrowser
include whitelist-common.inc

caps.drop all
netfilter
nodvd
nonewprivs
noroot
notv
protocol unix,inet,inet6,netlink
# blacklisting of chroot system calls breaks qt webengine
seccomp !chroot
# tracelog

#private-etc Trolltech.conf,X11,alsa,alternatives,asound.conf,bumblebee,ca-certificates,crypto-policies,dbus-1,drirc,fonts,glvnd,group,hosts,host.conf,hostname,ld.so.cache,ld.so.preload,ld.so.conf,ld.so.conf.d,locale,locale.alias,locale.conf,localtime,machine-id,mime.types,nsswitch.conf,pango,passwd,pki,protocols,pulse,resolv.conf,rpc,services,ssl,xdg

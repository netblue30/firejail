# Persistent global definitions go here
include /etc/firejail/globals.local

# This file is overwritten during software install.
# Persistent customizations should go in a .local file.
include /etc/firejail/cyberfox.local

# Firejail profile for Cyberfox (based on Mozilla Firefox)
noblacklist ~/.8pecxstudios
noblacklist ~/.cache/8pecxstudios
noblacklist ~/.config/qpdfview
noblacklist ~/.local/share/qpdfview
noblacklist ~/.kde4/share/apps/okular
noblacklist ~/.kde/share/apps/okular
noblacklist ~/.local/share/okular
noblacklist ~/.config/okularpartrc
noblacklist ~/.config/okularrc
noblacklist ~/.pki

include /etc/firejail/disable-common.inc
include /etc/firejail/disable-programs.inc
include /etc/firejail/disable-devel.inc

caps.drop all
# ipc-namespace crashes cyberfox on some setups
netfilter
nogroups
nonewprivs
noroot
protocol unix,inet,inet6,netlink
seccomp
shell none
tracelog

whitelist ${DOWNLOADS}
mkdir ~/.8pecxstudios
whitelist ~/.8pecxstudios
mkdir ~/.cache/8pecxstudios
whitelist ~/.cache/8pecxstudios
whitelist ~/dwhelper
whitelist ~/.zotero
whitelist ~/.vimperatorrc
whitelist ~/.vimperator
whitelist ~/.pentadactylrc
whitelist ~/.pentadactyl
whitelist ~/.keysnail.js
whitelist ~/.config/gnome-mplayer
whitelist ~/.cache/gnome-mplayer/plugin
mkdir ~/.pki
whitelist ~/.pki
whitelist ~/.lastpass
whitelist ~/.config/qpdfview
whitelist ~/.local/share/qpdfview
whitelist ~/.config/okularrc
whitelist ~/.config/okularpartrc
whitelist ~/.kde4/share/apps/okular
whitelist ~/.kde/share/apps/okular
whitelist ~/.local/share/okular

# silverlight
whitelist ~/.wine-pipelight
whitelist ~/.wine-pipelight64
whitelist ~/.config/pipelight-widevine
whitelist ~/.config/pipelight-silverlight5.1

include /etc/firejail/whitelist-common.inc

# experimental features
#private-bin cyberfox,which,sh,dbus-launch,dbus-send,env
#private-etc passwd,group,hostname,hosts,localtime,nsswitch.conf,resolv.conf,xdg,gtk-2.0,gtk-3.0,X11,pango,fonts,cyberfox,mime.types,mailcap,asound.conf,pulse
# private-dev might prevent video calls going out
private-dev
private-tmp

noexec ${HOME}
noexec /tmp

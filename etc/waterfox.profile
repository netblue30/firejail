# Firejail profile for waterfox
# This file is overwritten after every install/update
# Persistent local customizations
include /etc/firejail/waterfox.local
# Persistent global definitions
include /etc/firejail/globals.local

noblacklist ${HOME}/.cache/mozilla
noblacklist ${HOME}/.cache/waterfox
noblacklist ${HOME}/.config/okularpartrc
noblacklist ${HOME}/.config/okularrc
noblacklist ${HOME}/.config/qpdfview
noblacklist ${HOME}/.kde/share/apps/okular
noblacklist ${HOME}/.kde/share/config/okularpartrc
noblacklist ${HOME}/.kde/share/config/okularrc
noblacklist ${HOME}/.kde4/share/apps/okular
noblacklist ${HOME}/.kde4/share/config/okularpartrc
noblacklist ${HOME}/.kde4/share/config/okularrc
# noblacklist ${HOME}/.local/share/gnome-shell/extensions
noblacklist ${HOME}/.local/share/okular
noblacklist ${HOME}/.local/share/qpdfview
noblacklist ${HOME}/.mozilla
noblacklist ${HOME}/.waterfox
noblacklist ${HOME}/.pki

include /etc/firejail/disable-common.inc
include /etc/firejail/disable-devel.inc
include /etc/firejail/disable-programs.inc

mkdir ${HOME}/.cache/mozilla/firefox
mkdir ${HOME}/.mozilla
mkdir ${HOME}/.cache/waterfox
mkdir ${HOME}/.waterfox
mkdir ${HOME}/.pki
whitelist ${DOWNLOADS}
whitelist ${HOME}/.cache/gnome-mplayer/plugin
whitelist ${HOME}/.cache/mozilla/firefox
whitelist ${HOME}/.cache/waterfox
whitelist ${HOME}/.config/gnome-mplayer
whitelist ${HOME}/.config/okularpartrc
whitelist ${HOME}/.config/okularrc
whitelist ${HOME}/.config/pipelight-silverlight5.1
whitelist ${HOME}/.config/pipelight-widevine
whitelist ${HOME}/.config/qpdfview
whitelist ${HOME}/.kde/share/apps/okular
whitelist ${HOME}/.kde/share/config/okularpartrc
whitelist ${HOME}/.kde/share/config/okularrc
whitelist ${HOME}/.kde4/share/apps/okular
whitelist ${HOME}/.kde4/share/config/okularpartrc
whitelist ${HOME}/.kde4/share/config/okularrc
whitelist ${HOME}/.keysnail.js
whitelist ${HOME}/.lastpass
whitelist ${HOME}/.local/share/gnome-shell/extensions
whitelist ${HOME}/.local/share/okular
whitelist ${HOME}/.local/share/qpdfview
whitelist ${HOME}/.mozilla
whitelist ${HOME}/.waterfox
whitelist ${HOME}/.pentadactyl
whitelist ${HOME}/.pentadactylrc
whitelist ${HOME}/.pki
whitelist ${HOME}/.vimperator
whitelist ${HOME}/.vimperatorrc
whitelist ${HOME}/.wine-pipelight
whitelist ${HOME}/.wine-pipelight64
whitelist ${HOME}/.zotero
whitelist ${HOME}/dwhelper
include /etc/firejail/whitelist-common.inc
include /etc/firejail/whitelist-var-common.inc

caps.drop all
netfilter
nodvd
nogroups
nonewprivs
noroot
notv
protocol unix,inet,inet6,netlink
seccomp
shell none
tracelog

# waterfox requires a shell to launch on Arch. We can possibly remove sh though.
# private-bin waterfox,which,sh,dbus-launch,dbus-send,env,bash
private-dev
# private-etc passwd,group,hostname,hosts,localtime,nsswitch.conf,resolv.conf,xdg,gtk-2.0,gtk-3.0,X11,pango,fonts,waterfox,mime.types,mailcap,asound.conf,pulse
private-tmp

noexec ${HOME}
noexec /tmp

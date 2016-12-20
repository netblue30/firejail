# Firejail profile for Seamoneky based off Mozilla Firefox
noblacklist ~/.mozilla
noblacklist ~/.cache/mozilla
include /etc/firejail/disable-common.inc
include /etc/firejail/disable-programs.inc
include /etc/firejail/disable-devel.inc

caps.drop all
netfilter
nonewprivs
noroot
protocol unix,inet,inet6,netlink
seccomp
tracelog

whitelist ${DOWNLOADS}
mkdir ~/.mozilla/seamonkey
whitelist ~/.mozilla/seamonkey
mkdir ~/.cache/mozilla/seamonkey
whitelist ~/.cache/mozilla/seamonkey
whitelist ~/dwhelper
whitelist ~/.zotero
whitelist ~/.lastpass
whitelist ~/.vimperatorrc
whitelist ~/.vimperator
whitelist ~/.pentadactylrc
whitelist ~/.pentadactyl
whitelist ~/.keysnail.js
whitelist ~/.config/gnome-mplayer
whitelist ~/.cache/gnome-mplayer/plugin
whitelist ~/.pki
include /etc/firejail/whitelist-common.inc

# lastpass, keepass
# for keepass we additionally need to whitelist our .kdbx password database
whitelist ~/.keepass
whitelist ~/.config/keepass
whitelist ~/.config/KeePass
whitelist ~/.lastpass
whitelist ~/.config/lastpass

#silverlight
whitelist ~/.wine-pipelight
whitelist ~/.wine-pipelight64
whitelist ~/.config/pipelight-widevine
whitelist ~/.config/pipelight-silverlight5.1

# experimental features
#private-etc passwd,group,hostname,hosts,localtime,nsswitch.conf,resolv.conf,gtk-2.0,pango,fonts,iceweasel,firefox,adobe,mime.types,mailcap,asound.conf,pulse

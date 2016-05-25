# Firejail profile for Cyberfox (based on Mozilla Firefox)

noblacklist ~/.8pecxstudios/cyberfox
noblacklist ~/.cache/8pecxstudios
include /etc/firejail/disable-common.inc
include /etc/firejail/disable-programs.inc
include /etc/firejail/disable-devel.inc

caps.drop all
seccomp
protocol unix,inet,inet6,netlink
netfilter
tracelog
nonewprivs
noroot

whitelist ${DOWNLOADS}
mkdir ~/.8pecxstudios
whitelist ~/.8pecxstudios
mkdir ~/.cache
mkdir ~/.cache/8pecxstudios
mkdir ~/.cache/8pecxstudios/cyberfox
whitelist ~/.cache/8pecxstudios/cyberfox
whitelist ~/dwhelper
whitelist ~/.zotero
whitelist ~/.vimperatorrc
whitelist ~/.vimperator
whitelist ~/.pentadactylrc
whitelist ~/.pentadactyl
whitelist ~/.keysnail.js
whitelist ~/.config/gnome-mplayer
whitelist ~/.cache/gnome-mplayer/plugin
whitelist ~/.pki

# lastpass, keepassx
whitelist ~/.keepassx
whitelist ~/.config/keepassx
whitelist ~/keepassx.kdbx
whitelist ~/.lastpass
whitelist ~/.config/lastpass


#silverlight
whitelist ~/.wine-pipelight 
whitelist ~/.wine-pipelight64 
whitelist ~/.config/pipelight-widevine 
whitelist ~/.config/pipelight-silverlight5.1

include /etc/firejail/whitelist-common.inc

# experimental features
#private-etc passwd,group,hostname,hosts,localtime,nsswitch.conf,resolv.conf,gtk-2.0,pango,fonts,iceweasel,firefox,adobe,mime.types,mailcap,asound.conf,pulse


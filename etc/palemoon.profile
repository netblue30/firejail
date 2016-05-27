# Firejail profile for Pale Moon

# Noblacklists
noblacklist ~/.moonchild productions/pale moon
noblacklist ~/.cache/moonchild productions/pale moon

# Included profiles
include /etc/firejail/disable-common.inc
include /etc/firejail/disable-programs.inc
include /etc/firejail/disable-devel.inc
include /etc/firejail/whitelist-common.inc

# Options
caps.drop all
netfilter
nonewprivs
noroot
protocol unix,inet,inet6,netlink
seccomp
tracelog

whitelist ${DOWNLOADS}
mkdir ~/.moonchild productions
whitelist ~/.moonchild productions
mkdir ~/.cache
mkdir ~/.cache/moonchild productions
mkdir ~/.cache/moonchild productions/pale moon
whitelist ~/.cache/moonchild productions/pale moon

# These are uncommented in the Firefox profile. If you run into trouble you may
# want to uncomment (some of) them.
#whitelist ~/dwhelper
#whitelist ~/.zotero
#whitelist ~/.vimperatorrc
#whitelist ~/.vimperator
#whitelist ~/.pentadactylrc
#whitelist ~/.pentadactyl
#whitelist ~/.keysnail.js
#whitelist ~/.config/gnome-mplayer
#whitelist ~/.cache/gnome-mplayer/plugin
#whitelist ~/.pki

# For silverlight
#whitelist ~/.wine-pipelight
#whitelist ~/.wine-pipelight64
#whitelist ~/.config/pipelight-widevine
#whitelist ~/.config/pipelight-silverlight5.1


# lastpass, keepassx
whitelist ~/.keepassx
whitelist ~/.config/keepassx
whitelist ~/keepassx.kdbx
whitelist ~/.lastpass
whitelist ~/.config/lastpass

# experimental features
#private-etc passwd,group,hostname,hosts,localtime,nsswitch.conf,resolv.conf,gtk-2.0,pango,fonts,iceweasel,firefox,adobe,mime.types,mailcap,asound.conf,pulse

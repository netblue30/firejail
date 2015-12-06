# Firejail profile for Mozilla Firefox (Iceweasel in Debian)
noblacklist ${HOME}/.mozilla
include /etc/firejail/disable-mgmt.inc
include /etc/firejail/disable-secret.inc
include /etc/firejail/disable-common.inc
include /etc/firejail/disable-devel.inc
caps.drop all
seccomp
protocol unix,inet,inet6,netlink
netfilter
tracelog
noroot
whitelist ${DOWNLOADS}
whitelist ~/.mozilla
whitelist ~/.cache/mozilla/firefox
whitelist ~/dwhelper
whitelist ~/.zotero
whitelist ~/.lastpass
whitelist ~/.vimperatorrc
whitelist ~/.vimperator
whitelist ~/.pentadactylrc
whitelist ~/.pentadactyl
whitelist ~/.config/gnome-mplayer
whitelist ~/.cache/gnome-mplayer/plugin
include /etc/firejail/whitelist-common.inc

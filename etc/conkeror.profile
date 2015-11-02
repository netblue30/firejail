# Firejail profile for Mozilla Firefox (Iceweasel in Debian)
noblacklist ${HOME}/.conkeror.mozdev.org
include /etc/firejail/disable-mgmt.inc
include /etc/firejail/disable-secret.inc
include /etc/firejail/disable-common.inc
caps.drop all
seccomp
protocol unix,inet,inet6
netfilter
noroot
whitelist ~/.conkeror.mozdev.org
whitelist ~/Downloads
whitelist ~/dwhelper
whitelist ~/.zotero
whitelist ~/.lastpass
whitelist ~/.gtkrc-2.0
whitelist ~/.vimperatorrc
whitelist ~/.vimperator
whitelist ~/.pentadactylrc
whitelist ~/.pentadactyl
whitelist ~/.conkerorrc

# common
whitelist ~/.fonts
whitelist ~/.fonts.d
whitelist ~/.fontconfig
whitelist ~/.fonts.conf
whitelist ~/.fonts.conf.d

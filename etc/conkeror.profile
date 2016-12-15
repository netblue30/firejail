# Firejail profile for Conkeror web browser profile
noblacklist ${HOME}/.conkeror.mozdev.org
include /etc/firejail/disable-common.inc
include /etc/firejail/disable-programs.inc

caps.drop all
netfilter
nonewprivs
noroot
protocol unix,inet,inet6
seccomp

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
include /etc/firejail/whitelist-common.inc

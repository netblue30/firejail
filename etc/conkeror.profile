# Firejail profile for conkeror
# This file is overwritten after every install/update
# Persistent local customizations
include /etc/firejail/conkeror.local
# Persistent global definitions
include /etc/firejail/globals.local

noblacklist ${HOME}/.conkeror.mozdev.org

include /etc/firejail/disable-common.inc
include /etc/firejail/disable-programs.inc

whitelist ~/.conkeror.mozdev.org
whitelist ~/.conkerorrc
whitelist ~/.gtkrc-2.0
whitelist ~/.lastpass
whitelist ~/.pentadactyl
whitelist ~/.pentadactylrc
whitelist ~/.vimperator
whitelist ~/.vimperatorrc
whitelist ~/.zotero
whitelist ~/Downloads
whitelist ~/dwhelper
include /etc/firejail/whitelist-common.inc

caps.drop all
netfilter
nodvd
nonewprivs
noroot
notv
protocol unix,inet,inet6
seccomp

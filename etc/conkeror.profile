# Firejail profile for conkeror
# This file is overwritten after every install/update
# Persistent local customizations
include /etc/firejail/conkeror.local
# Persistent global definitions
include /etc/firejail/globals.local

noblacklist ${HOME}/.conkeror.mozdev.org

include /etc/firejail/disable-common.inc
include /etc/firejail/disable-programs.inc

whitelist ${HOME}/.conkeror.mozdev.org
whitelist ${HOME}/.conkerorrc
whitelist ${HOME}/.gtkrc-2.0
whitelist ${HOME}/.lastpass
whitelist ${HOME}/.pentadactyl
whitelist ${HOME}/.pentadactylrc
whitelist ${HOME}/.vimperator
whitelist ${HOME}/.vimperatorrc
whitelist ${HOME}/.zotero
whitelist ${HOME}/Downloads
whitelist ${HOME}/dwhelper
include /etc/firejail/whitelist-common.inc

caps.drop all
netfilter
nodvd
nonewprivs
noroot
notv
protocol unix,inet,inet6
seccomp

disable-mnt

# Firejail profile for conkeror
# This file is overwritten after every install/update
# Persistent local customizations
include conkeror.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.conkeror.mozdev.org

include disable-common.inc
include disable-programs.inc

mkdir ${HOME}/.conkeror.mozdev.org
mkfile ${HOME}/.conkerorrc
whitelist ${HOME}/.conkeror.mozdev.org
whitelist ${HOME}/.conkerorrc
whitelist ${HOME}/.lastpass
whitelist ${HOME}/.pentadactyl
whitelist ${HOME}/.pentadactylrc
whitelist ${HOME}/.vimperator
whitelist ${HOME}/.vimperatorrc
whitelist ${HOME}/.zotero
whitelist ${HOME}/dwhelper
whitelist ${DOWNLOADS}
include whitelist-common.inc

caps.drop all
netfilter
nodvd
nonewprivs
noroot
notv
protocol unix,inet,inet6
seccomp

disable-mnt

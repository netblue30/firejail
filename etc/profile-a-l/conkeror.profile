# Firejail profile for conkeror
# This file is overwritten after every install/update
# Persistent local customizations
include conkeror.local
# Persistent global definitions
include globals.local

nodeny  ${HOME}/.conkeror.mozdev.org

include disable-common.inc
include disable-programs.inc

mkdir ${HOME}/.conkeror.mozdev.org
mkfile ${HOME}/.conkerorrc
allow  ${HOME}/.conkeror.mozdev.org
allow  ${HOME}/.conkerorrc
allow  ${HOME}/.lastpass
allow  ${HOME}/.pentadactyl
allow  ${HOME}/.pentadactylrc
allow  ${HOME}/.vimperator
allow  ${HOME}/.vimperatorrc
allow  ${HOME}/.zotero
allow  ${HOME}/dwhelper
allow  ${DOWNLOADS}
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

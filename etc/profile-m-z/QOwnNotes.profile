# Firejail profile for QOwnNotes
# Description: Plain-text file notepad with markdown support and ownCloud integration
# This file is overwritten after every install/update
# Persistent local customizations
include QOwnNotes.local
# Persistent global definitions
include globals.local

noblacklist ${DOCUMENTS}
noblacklist ${HOME}/Nextcloud/Notes
noblacklist ${HOME}/.config/PBE
noblacklist ${HOME}/.local/share/PBE

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-programs.inc
include disable-shell.inc
include disable-xdg.inc

mkdir ${HOME}/Nextcloud/Notes
mkdir ${HOME}/.config/PBE
mkdir ${HOME}/.local/share/PBE
whitelist ${DOCUMENTS}
whitelist ${HOME}/Nextcloud/Notes
whitelist ${HOME}/.config/PBE
whitelist ${HOME}/.local/share/PBE
include whitelist-common.inc
include whitelist-var-common.inc

caps.drop all
machine-id
netfilter
no3d
nodvd
nogroups
noinput
nonewprivs
noroot
nosound
notv
nou2f
novideo
protocol unix,inet,inet6,netlink
seccomp
tracelog

disable-mnt
private-bin QOwnNotes,gio
private-dev
private-etc @tls-ca,host.conf
private-tmp

restrict-namespaces

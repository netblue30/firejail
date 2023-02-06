# Firejail profile for qcomicbook
# Description: A comic book and manga viewer in QT
# This file is overwritten after every install/update
# Persistent local customizations
include qcomicbook.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.cache/PawelStolowski
noblacklist ${HOME}/.config/PawelStolowski
noblacklist ${HOME}/.local/share/PawelStolowski
noblacklist ${DOCUMENTS}

# Allow /bin/sh (blacklisted by disable-shell.inc)
include allow-bin-sh.inc

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-programs.inc
include disable-shell.inc
include disable-write-mnt.inc
include disable-xdg.inc

mkdir ${HOME}/.cache/PawelStolowski
mkdir ${HOME}/.config/PawelStolowski
mkdir ${HOME}/.local/share/PawelStolowski
whitelist /usr/share/qcomicbook
include whitelist-runuser-common.inc
include whitelist-usr-share-common.inc
include whitelist-var-common.inc

apparmor
caps.drop all
machine-id
net none
nodvd
nogroups
noinput
nonewprivs
noroot
nosound
notv
nou2f
novideo
protocol unix
seccomp
seccomp.block-secondary
tracelog

private-bin 7z,7zr,qcomicbook,rar,sh,tar,unace,unrar,unzip
private-cache
private-dev
private-etc @x11,mime.types
private-tmp

dbus-user none
dbus-system none

read-only ${HOME}
read-write ${HOME}/.cache/PawelStolowski
read-write ${HOME}/.config/PawelStolowski
read-write ${HOME}/.local/share/PawelStolowski
#to allow ${HOME}/.local/share/recently-used.xbel
read-write ${HOME}/.local/share
restrict-namespaces

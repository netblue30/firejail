# Firejail profile for qnapi
# Description: Qt client for downloading movie subtitles from NapiProjekt, OpenSubtitles and Napisy24
# This file is overwritten after every install/update
# Persistent local customizations
include qnapi.local
# Persistent global definitions
include globals.local

nodeny  ${HOME}/.config/qnapi.ini

ignore noexec /tmp

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc
include disable-shell.inc
include disable-xdg.inc

mkfile ${HOME}/.config/qnapi.ini
allow  ${HOME}/.config/qnapi.ini
allow  ${DOWNLOADS}
include whitelist-common.inc
include whitelist-usr-share-common.inc
include whitelist-runuser-common.inc
include whitelist-var-common.inc

apparmor
caps.drop all
ipc-namespace
netfilter
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
shell none
tracelog

private-bin 7z,qnapi
private-cache
private-dev
private-etc alternatives,fonts
private-opt none
private-tmp

dbus-user none
dbus-system none

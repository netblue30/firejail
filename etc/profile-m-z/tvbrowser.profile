# Firejail profile for tvbrowser
# Description: java tv programm form tvbrowser.org
# This file is overwritten after every install/update
# Persistent local customizations
include tvbrowser.local
# Persistent global definitions
include globals.local

nodeny  ${HOME}/.config/tvbrowser
nodeny  ${HOME}/.tvbrowser

# Allow java (blacklisted by disable-devel.inc)
include allow-java.inc

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc
include disable-xdg.inc

mkdir ${HOME}/.config/tvbrowser
mkdir ${HOME}/.tvbrowser
allow  ${HOME}/.config/tvbrowser
allow  ${HOME}/.tvbrowser
allow  /usr/share/tvbrowser
include whitelist-common.inc
include whitelist-usr-share-common.inc
include whitelist-var-common.inc

caps.drop all
netfilter
no3d
nodvd
nogroups
noinput
nonewprivs
noroot
notv
nou2f
novideo
protocol unix,inet,inet6
seccomp
shell none
tracelog

disable-mnt
private-cache
private-dev
private-tmp

dbus-user none
dbus-system none

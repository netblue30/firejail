# Firejail profile for feedreader
# Description: RSS client
# This file is overwritten after every install/update
# Persistent local customizations
include feedreader.local
# Persistent global definitions
include globals.local

nodeny  ${HOME}/.cache/feedreader
nodeny  ${HOME}/.local/share/feedreader

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc
include disable-shell.inc
include disable-xdg.inc

mkdir ${HOME}/.cache/feedreader
mkdir ${HOME}/.local/share/feedreader
allow  ${HOME}/.cache/feedreader
allow  ${HOME}/.local/share/feedreader
allow  /usr/share/feedreader
include whitelist-common.inc
include whitelist-runuser-common.inc
include whitelist-usr-share-common.inc
include whitelist-var-common.inc

caps.drop all
netfilter
# no3d
nodvd
nogroups
noinput
nonewprivs
noroot
# nosound
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

dbus-user filter
dbus-user.own org.gnome.FeedReader
dbus-user.own org.gnome.FeedReader.ArticleView
dbus-user.talk org.freedesktop.secrets
# Enable as you need.
#dbus-user.talk org.freedesktop.Notifications
#dbus-user.talk org.gnome.OnlineAccounts
dbus-system none

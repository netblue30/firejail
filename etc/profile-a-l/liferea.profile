# Firejail profile for liferea
# Description: Feed/news/podcast client with plugin support
# This file is overwritten after every install/update
# Persistent local customizations
include liferea.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.cache/liferea
noblacklist ${HOME}/.config/liferea
noblacklist ${HOME}/.local/share/liferea

# Allow python (blacklisted by disable-interpreters.inc)
include allow-python2.inc
include allow-python3.inc

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc

mkdir ${HOME}/.cache/liferea
mkdir ${HOME}/.config/liferea
mkdir ${HOME}/.local/share/liferea
whitelist ${HOME}/.cache/liferea
whitelist ${HOME}/.config/liferea
whitelist ${HOME}/.local/share/liferea
whitelist /usr/share/liferea
include whitelist-common.inc
include whitelist-runuser-common.inc
include whitelist-usr-share-common.inc
include whitelist-var-common.inc

caps.drop all
netfilter
# no3d
nodvd
nogroups
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
#private-bin liferea
private-dev
private-etc alternatives,ca-certificates,crypto-policies,dconf,fonts,gtk-2.0,gtk-3.0,hostname,hosts,login.defs,mime.types,nsswitch.conf,pki,pulse,resolv.conf,ssl,X11,xdg
private-tmp

dbus-user filter
dbus-user.own net.sourceforge.liferea
dbus-user.talk ca.desrt.dconf
# Add the below line to 'liferea.local' to use the 'Popup Notifications' plugin
# dbus-user.talk org.freedesktop.Notifications
# Add the below line to 'liferea.local' to use the 'Libsecret' plugin
# dbus-user.talk org.freedesktop.secrets
dbus-system none

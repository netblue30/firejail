# Firejail profile for rtv
# Description: Browse Reddit from your terminal
# This file is overwritten after every install/update
# Persistent local customizations
include rtv.local
# Persistent global definitions
include globals.local

deny  /tmp/.X11-unix
deny  ${RUNUSER}/wayland-*

nodeny  ${HOME}/.config/rtv
nodeny  ${HOME}/.local/share/rtv

# Allow /bin/sh (blacklisted by disable-shell.inc)
include allow-bin-sh.inc

# Allow python (blacklisted by disable-interpreters.inc)
include allow-python2.inc
include allow-python3.inc

# You can configure rtv to open different type of links in external applications.
# Configuration: https://github.com/michael-lazar/rtv#viewing-media-links.
# Add the next line to your rtv.local to enable external application support.
#include rtv-addons.profile
include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc
include disable-xdg.inc

mkdir ${HOME}/.config/rtv
mkdir ${HOME}/.local/share/rtv
allow  ${HOME}/.config/rtv
allow  ${HOME}/.local/share/rtv
include whitelist-var-common.inc

apparmor
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
protocol unix,inet,inet6
seccomp
shell none
tracelog

disable-mnt
private-bin less,python*,rtv,sh,xdg-settings
private-cache
private-dev
private-etc alternatives,ca-certificates,crypto-policies,host.conf,hostname,hosts,ld.so.cache,ld.so.conf,ld.so.conf.d,ld.so.preload,locale,locale.alias,locale.conf,localtime,mailcap,mime.types,nsswitch.conf,pki,protocols,resolv.conf,rpc,services,ssl,terminfo,xdg

dbus-user none
dbus-system none

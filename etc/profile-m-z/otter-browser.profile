# Firejail profile for otter-browser
# Description: Lightweight web browser based on Qt5
# This file is overwritten after every install/update
# Persistent local customizations
include otter-browser.local
# Persistent global definitions
include globals.local

?BROWSER_ALLOW_DRM: ignore noexec ${HOME}

nodeny  ${HOME}/.cache/Otter
nodeny  ${HOME}/.config/otter
nodeny  ${HOME}/.pki
nodeny  ${HOME}/.local/share/pki

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc
include disable-xdg.inc

mkdir ${HOME}/.cache/Otter
mkdir ${HOME}/.config/otter
mkdir ${HOME}/.pki
mkdir ${HOME}/.local/share/pki
allow  ${DOWNLOADS}
allow  ${HOME}/.cache/Otter
allow  ${HOME}/.config/otter
allow  ${HOME}/.pki
allow  ${HOME}/.local/share/pki
allow  /usr/share/otter-browser
include whitelist-common.inc
include whitelist-runuser-common.inc
include whitelist-usr-share-common.inc
include whitelist-var-common.inc

apparmor
caps.drop all
netfilter
nodvd
nogroups
noinput
nonewprivs
noroot
notv
?BROWSER_DISABLE_U2F: nou2f
protocol unix,inet,inet6,netlink
seccomp !chroot
shell none

disable-mnt
private-bin bash,otter-browser,sh,which
private-cache
?BROWSER_DISABLE_U2F: private-dev
private-etc alternatives,asound.conf,ca-certificates,crypto-policies,dconf,fonts,group,gtk-2.0,gtk-3.0,hostname,hosts,ld.so.cache,ld.so.conf,ld.so.conf.d,ld.so.preload,localtime,machine-id,mailcap,mime.types,nsswitch.conf,pango,passwd,pki,pulse,resolv.conf,selinux,ssl,X11,xdg
private-tmp

dbus-system none

# Firejail profile for remmina
# Description: GTK+ Remote Desktop Client
# This file is overwritten after every install/update
# Persistent local customizations
include remmina.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.remmina
noblacklist ${HOME}/.config/remmina
noblacklist ${HOME}/.local/share/remmina
noblacklist ${HOME}/.ssh

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc
include disable-xdg.inc

include whitelist-var-common.inc

caps.drop all
nodvd
nogroups
nonewprivs
noroot
notv
nou2f
novideo
protocol unix,inet,inet6
seccomp
shell none

private-cache
private-dev
private-etc SuSE-release,UnitedLinux-release,X11,alsa,alternatives,annvix-release,arch-release,arklinux-release,asound.conf,aurox-release,blackcat-release,bumblebee,ca-certificates,cobalt-release,conectiva-release,crypto-policies,dbus-1,dconf,debian_release,debian_version,drirc,e-smith-release,fedora-release,fonts,gconf,gentoo-release,glvnd,gtk-2.0,gtk-3.0,hosts,host.conf,hostname,immunix-release,knoppix_version,ld.so.cache,ld.so.preload,ld.so.conf,ld.so.conf.d,lfs-release,linuxppc-release,locale,locale.alias,locale.conf,localtime,lsb-release,machine-id,mandrake-release,mandrakelinux-release,mandriva-release,mime.types,mklinux-release,nld-release,novell-release,nsswitch.conf,os-release,pango,passwd,pki,pld-release,protocols,pulse,redhat-release,redhat_version,release,resolv.conf,rpc,services,slackware-release,slackware-version,sles-release,solus-release,ssl,sun-release,tinysofa-release,turbolinux-release,ultrapenguin-release,va-release,xdg,yellowdog-release
private-tmp


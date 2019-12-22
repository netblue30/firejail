# Firejail profile for gradio
# This file is overwritten after every install/update
# Persistent local customizations
include gradio.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.cache/gradio
noblacklist ${HOME}/.local/share/gradio

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc

mkdir ${HOME}/.cache/gradio
mkdir ${HOME}/.local/share/gradio
whitelist ${HOME}/.cache/gradio
whitelist ${HOME}/.local/share/gradio
include whitelist-common.inc
include whitelist-var-common.inc

caps.drop all
netfilter
no3d
nodvd
nogroups
nonewprivs
noroot
notv
novideo
protocol unix,inet,inet6
seccomp
shell none

private-etc Trolltech.conf,X11,alsa,alternatives,asound.conf,ca-certificates,crypto-policies,dbus-1,dconf,fonts,gconf,gtk-2.0,gtk-3.0,hosts,host.conf,hostname,ld.so.cache,ld.so.preload,ld.so.conf,ld.so.conf.d,locale,locale.alias,locale.conf,localtime,machine-id,mime.types,nsswitch.conf,pango,passwd,pki,protocols,pulse,resolv.conf,rpc,services,ssl,xdg
private-tmp


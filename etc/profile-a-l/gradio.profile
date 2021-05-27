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
include disable-xdg.inc

mkdir ${HOME}/.cache/gradio
mkdir ${HOME}/.local/share/gradio
whitelist ${HOME}/.cache/gradio
whitelist ${HOME}/.local/share/gradio
include whitelist-common.inc
include whitelist-runuser-common.inc
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
seccomp.block-secondary
shell none
tracelog

disable-mnt
private-bin gradio
private-cache
private-dev
private-etc alternatives,asound.conf,ca-certificates,crypto-policies,fonts,gtk-3.0,host.conf,hostname,hosts,machine-id,pki,pulse,resolv.conf,ssl,xdg
private-tmp

dbus-user filter
dbus-user.own de.haeckerfelix.gradio
dbus-user.own org.mpris.MediaPlayer2.gradio
dbus-user.talk ca.desrt.dconf
dbus-system none

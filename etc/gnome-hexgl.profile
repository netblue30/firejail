# Firejail profile for gnome-hexgl
# Description: Gthree port of HexGL
# This file is overwritten after every install/update
# Persistent local customizations
include gnome-hexgl.local
# Persistent global definitions
include globals.local

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc
include disable-xdg.inc

mkdir ${HOME}/.cache/mesa_shader_cache
whitelist /usr/share/gnome-hexgl
include whitelist-runuser-common.inc
include whitelist-usr-share-common.inc
include whitelist-var-common.inc

apparmor
caps.drop all
net none
nodbus
nodvd
nogroups
nonewprivs
noroot
notv
nou2f
novideo
protocol unix
seccomp
shell none
tracelog

disable-mnt
private
private-bin gnome-hexgl
private-cache
private-dev
private-etc machine-id
private-tmp

read-only ${HOME}
read-write ${HOME}/.cache/mesa_shader_cache

# Firejail profile for devhelp
# Description: API documentation browser for GNOME
# This file is overwritten after every install/update
# Persistent local customizations
include devhelp.local
# Persistent global definitions
include globals.local

mkdir ${HOME}/.cache/mesa_shader_cache
whitelist ${HOME}/.cache/mesa_shader_cache

include disable-common.inc
include disable-devel.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc
include disable-xdg.inc

include whitelist-common.inc

apparmor
caps.drop all
machine-id
net none
# nodbus - makes settings immutable
nodvd
nogroups
nonewprivs
noroot
nosound
notv
nou2f
novideo
protocol unix
seccomp
shell none
tracelog

disable-mnt
private-bin devhelp
private-cache
private-dev
private-etc alternatives,fonts
private-tmp

# memory-deny-write-execute - Breaks on Arch
noexec ${HOME}
noexec /tmp

# devhelp will never write anything
read-only ${HOME}

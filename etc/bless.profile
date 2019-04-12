# Firejail profile for bless
# Description: A full featured hexadecimal editor
# This file is overwritten after every install/update
# Persistent local customizations
include bless.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.config/bless

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc

include whitelist-var-common.inc

caps.drop all
net none
no3d
nodbus
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

# private-bin bless,sh,bash,mono
private-cache
private-dev
private-etc alternatives,fonts,mono
private-tmp


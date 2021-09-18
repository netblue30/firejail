# Firejail profile for masterpdfeditor
# Description: A complete solution for creating and editing PDF files
# This file is overwritten after every install/update
# Persistent local customizations
include masterpdfeditor.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.config/Code Industry
noblacklist ${HOME}/.masterpdfeditor

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-programs.inc

include whitelist-var-common.inc

apparmor
caps.drop all
machine-id
nodvd
nogroups
noinput
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

private-cache
private-dev
private-etc alternatives,fonts,ld.so.preload
private-tmp


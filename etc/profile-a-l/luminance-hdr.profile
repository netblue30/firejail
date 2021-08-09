# Firejail profile for luminance-hdr
# Description: Graphical user interface providing a workflow for HDR imaging
# This file is overwritten after every install/update
# Persistent local customizations
include luminance-hdr.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.config/Luminance
noblacklist ${PICTURES}

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-programs.inc
include disable-xdg.inc

caps.drop all
netfilter
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

#private-bin luminance-hdr,luminance-hdr-cli,align_image_stack
private-cache
private-dev
private-tmp


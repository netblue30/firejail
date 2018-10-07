# Firejail profile for luminance-hdr
# Description: Graphical user interface providing a workflow for HDR imaging
# This file is overwritten after every install/update
# Persistent local customizations
include /etc/firejail/luminance-hdr.local
# Persistent global definitions
include /etc/firejail/globals.local

noblacklist ${HOME}/.config/Luminance
noblacklist ${PICTURES}

include /etc/firejail/disable-common.inc
include /etc/firejail/disable-devel.inc
include /etc/firejail/disable-interpreters.inc
include /etc/firejail/disable-passwdmgr.inc
include /etc/firejail/disable-programs.inc
include /etc/firejail/disable-xdg.inc

caps.drop all
netfilter
nodvd
nogroups
nonewprivs
noroot
nosound
notv
novideo
protocol unix
seccomp
shell none
tracelog

#private-bin luminance-hdr,luminance-hdr-cli,align_image_stack
private-cache
private-dev
private-tmp

noexec ${HOME}
noexec /tmp

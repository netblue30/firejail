# Firejail profile for luminance-hdr
# This file is overwritten after every install/update
# Persistent local customizations
include /etc/firejail/luminance-hdr.local
# Persistent global definitions
include /etc/firejail/globals.local

noblacklist ${HOME}/.config/Luminance

include /etc/firejail/disable-common.inc
include /etc/firejail/disable-devel.inc
include /etc/firejail/disable-interpreters.inc
include /etc/firejail/disable-passwdmgr.inc
include /etc/firejail/disable-programs.inc

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
private-dev
private-tmp

noexec ${HOME}
noexec /tmp

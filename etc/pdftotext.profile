# Firejail profile for pdftotext
# This file is overwritten after every install/update
# Persistent local customizations
include /etc/firejail/pdftotext.local
# Persistent global definitions
include /etc/firejail/globals.local

blacklist /tmp/.X11-unix

include /etc/firejail/disable-common.inc
include /etc/firejail/disable-devel.inc
include /etc/firejail/disable-passwdmgr.inc
include /etc/firejail/disable-programs.inc

caps.drop all
net none
no3d
nogroups
nonewprivs
noroot
nosound
novideo
protocol unix
seccomp
shell none
tracelog

private-bin pdftotext
private-dev
private-etc none
private-tmp

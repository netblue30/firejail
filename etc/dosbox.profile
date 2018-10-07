# Firejail profile for dosbox
# Description: x86 emulator with Tandy/Herc/CGA/EGA/VGA/SVGA graphics, sound and DOS
# This file is overwritten after every install/update
# Persistent local customizations
include /etc/firejail/dosbox.local
# Persistent global definitions
include /etc/firejail/globals.local

noblacklist ${HOME}/.dosbox
noblacklist ${DOCUMENTS}

include /etc/firejail/disable-common.inc
include /etc/firejail/disable-devel.inc
include /etc/firejail/disable-interpreters.inc
include /etc/firejail/disable-passwdmgr.inc
include /etc/firejail/disable-programs.inc
include /etc/firejail/disable-xdg.inc

include /etc/firejail/whitelist-var-common.inc

caps.drop all
netfilter
nodvd
nogroups
nonewprivs
noroot
notv
novideo
protocol unix,inet,inet6
seccomp
shell none
tracelog

private-bin dosbox
private-dev
private-tmp

# Firejail profile for dosbox
# Description: x86 emulator with Tandy/Herc/CGA/EGA/VGA/SVGA graphics, sound and DOS
# This file is overwritten after every install/update
# Persistent local customizations
include dosbox.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.dosbox
noblacklist ${DOCUMENTS}

include disable-common.inc
include disable-devel.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc
include disable-xdg.inc

include whitelist-var-common.inc

caps.drop all
netfilter
nodvd
nogroups
nonewprivs
noroot
notv
nou2f
novideo
protocol unix,inet,inet6
seccomp
shell none
tracelog

private-bin dosbox
private-dev
private-tmp

# Firejail profile for xpdf
# Description: Portable Document Format (PDF) reader
# This file is overwritten after every install/update
# Persistent local customizations
include xpdf.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.xpdfrc
noblacklist ${DOCUMENTS}

include disable-common.inc
include disable-devel.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc
include disable-xdg.inc

include whitelist-var-common.inc

caps.drop all
# machine-id breaks audio; it should work fine in setups where sound is not required
machine-id
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

private-dev
private-tmp

noexec ${HOME}
noexec /tmp

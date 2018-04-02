# Firejail profile for inkscape
# This file is overwritten after every install/update
# Persistent local customizations
include /etc/firejail/inkscape.local
# Persistent global definitions
include /etc/firejail/globals.local

noblacklist ${HOME}/.cache/inkscape
noblacklist ${HOME}/.config/inkscape
noblacklist ${HOME}/.inkscape

include /etc/firejail/disable-common.inc
include /etc/firejail/disable-devel.inc
include /etc/firejail/disable-interpreters.inc
include /etc/firejail/disable-passwdmgr.inc
include /etc/firejail/disable-programs.inc

include /etc/firejail/whitelist-var-common.inc

apparmor
caps.drop all
net none
nodbus
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

# private-bin inkscape,potrace - problems on Debian stretch
private-dev
private-tmp

noexec ${HOME}
noexec /tmp

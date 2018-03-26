# Firejail profile for synfigstudio
# This file is overwritten after every install/update
# Persistent local customizations
include /etc/firejail/synfigstudio.local
# Persistent global definitions
include /etc/firejail/globals.local

noblacklist ${HOME}/.config/synfig
noblacklist ${HOME}/.synfig

include /etc/firejail/disable-common.inc
include /etc/firejail/disable-devel.inc
include /etc/firejail/disable-interpreters.inc
include /etc/firejail/disable-passwdmgr.inc
include /etc/firejail/disable-programs.inc

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

#private-bin synfigstudio,synfig,ffmpeg
private-dev
private-tmp

noexec ${HOME}
noexec /tmp

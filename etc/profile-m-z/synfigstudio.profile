# Firejail profile for synfigstudio
# Description: Vector-based 2D animation package
# This file is overwritten after every install/update
# Persistent local customizations
include synfigstudio.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.config/synfig
noblacklist ${HOME}/.synfig

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc

caps.drop all
net none
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

#private-bin ffmpeg,synfig,synfigstudio
private-cache
private-dev
private-tmp

dbus-user none
dbus-system none

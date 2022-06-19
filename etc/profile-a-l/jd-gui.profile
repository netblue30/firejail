# Firejail profile for jd-gui
# This file is overwritten after every install/update
# Persistent local customizations
include jd-gui.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.config/jd-gui.cfg

# Allow java (blacklisted by disable-devel.inc)
include allow-java.inc

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-programs.inc
include disable-xdg.inc

include whitelist-var-common.inc

caps.drop all
net none
no3d
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

private-bin bash,jd-gui,sh
private-cache
private-dev
private-tmp

dbus-user none
dbus-system none

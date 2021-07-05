# Firejail profile for obs
# This file is overwritten after every install/update
# Persistent local customizations
include obs.local
# Persistent global definitions
include globals.local

nodeny  ${HOME}/.config/obs-studio
nodeny  ${MUSIC}
nodeny  ${PICTURES}
nodeny  ${VIDEOS}

# Allow python (blacklisted by disable-interpreters.inc)
include allow-python2.inc
include allow-python3.inc

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc
include disable-xdg.inc

include whitelist-var-common.inc

caps.drop all
nodvd
nogroups
noinput
nonewprivs
noroot
notv
nou2f
protocol unix,inet,inet6
seccomp
shell none
tracelog

private-bin bash,obs,obs-ffmpeg-mux,python*,sh
private-cache
private-dev
private-tmp


# Firejail profile for obs
# This file is overwritten after every install/update
# Persistent local customizations
include obs.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.config/obs-studio
noblacklist ${MUSIC}
noblacklist ${PICTURES}
noblacklist ${VIDEOS}

# Allow lua (blacklisted by disable-interpreters.inc)
include allow-lua.inc

# Allow python (blacklisted by disable-interpreters.inc)
include allow-python2.inc
include allow-python3.inc

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
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
tracelog

private-bin bash,obs,obs-ffmpeg-mux,python*,sh
private-cache
private-dev
private-tmp

restrict-namespaces

# Firejail profile for youtube-dl
# Description: Downloader of videos from YouTube and other sites
# This file is overwritten after every install/update
quiet
# Persistent local customizations
include youtube-dl.local
# Persistent global definitions
include globals.local

# breaks when installed under ${HOME} via `pip install --user` (see #2833)
ignore noexec ${HOME}

noblacklist ${HOME}/.cache/youtube-dl
noblacklist ${HOME}/.config/youtube-dl
noblacklist ${HOME}/.netrc
noblacklist ${MUSIC}
noblacklist ${VIDEOS}

# Allow python (blacklisted by disable-interpreters.inc)
include allow-python2.inc
include allow-python3.inc

blacklist /tmp/.X11-unix
blacklist ${RUNUSER}

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc
include disable-shell.inc
include disable-xdg.inc

include whitelist-usr-share-common.inc
include whitelist-var-common.inc

apparmor
caps.drop all
ipc-namespace
machine-id
netfilter
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
protocol unix,inet,inet6
seccomp
seccomp.block-secondary
shell none
tracelog

private-bin env,ffmpeg,python*,youtube-dl
private-cache
private-dev
private-etc alternatives,ca-certificates,crypto-policies,hostname,hosts,ld.so.cache,mime.types,pki,resolv.conf,ssl,youtube-dl.conf
private-tmp

dbus-user none
dbus-system none

#memory-deny-write-execute - breaks on Arch (see issue #1803)

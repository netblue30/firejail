# Firejail profile for youtube-dl
# Description: Downloader of videos from YouTube and other sites
# This file is overwritten after every install/update
quiet
# Persistent local customizations
include youtube-dl.local
# Persistent global definitions
include globals.local

# breaks when installed via pip
ignore noexec ${HOME}

noblacklist ${HOME}/.netrc
noblacklist ${MUSIC}
noblacklist ${VIDEOS}

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

apparmor
caps.drop all
ipc-namespace
machine-id
netfilter
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
protocol unix,inet,inet6
seccomp
shell none
tracelog

disable-mnt
private-bin env,ffmpeg,python*,youtube-dl
private-cache
private-dev
private-etc alternatives,ca-certificates,crypto-policies,hostname,hosts,mime.types,pki,resolv.conf,ssl,youtube-dl.conf
private-tmp

#memory-deny-write-execute - breaks on Arch (see issue #1803)

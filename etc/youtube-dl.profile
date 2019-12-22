# Firejail profile for youtube-dl
# Description: Downloader of videos from YouTube and other sites
# This file is overwritten after every install/update
quiet
# Persistent local customizations
include youtube-dl.local
# Persistent global definitions
include globals.local

# breaks when installed under ${HOME} via `pip install --user` (see #2833)
private-etc alternatives,ca-certificates,crypto-policies,hosts,host.conf,hostname,ld.so.cache,ld.so.preload,ld.so.conf,ld.so.conf.d,locale,locale.alias,locale.conf,localtime,mime.types,nsswitch.conf,passwd,pki,protocols,resolv.conf,rpc,services,ssl,xdg,youtube-dl,youtube-dl.conf
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

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc
include disable-xdg.inc

include whitelist-usr-share-common.inc
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

private-bin env,ffmpeg,python*,youtube-dl
private-cache
private-dev
private-tmp

#memory-deny-write-execute - breaks on Arch (see issue #1803)

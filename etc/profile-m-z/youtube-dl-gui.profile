# Firejail profile for youtube-dl-gui
# Description: A cross platform front-end GUI of the popular youtube-dl media downloader
include youtube-dl-gui.local
# This file is overwritten after every install/update
include globals.local

#These are blacklisted by disable-interpreters.inc
include allow-python2.inc
include allow-python3.inc

noblacklist ${HOME}/.config/youtube-dlg
noblacklist ${VIDEOS}

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc
include disable-shell.inc
include disable-xdg.inc

mkdir ${HOME}/.config/youtube-dlg
whitelist ${HOME}/.config/youtube-dlg
whitelist ${VIDEOS}
include whitelist-common.inc
include whitelist-runuser-common.inc
include whitelist-usr-share-common.inc
include whitelist-var-common.inc

apparmor
caps.drop all
machine-id
netfilter
no3d
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
seccomp.block-secondary
shell none
tracelog

disable-mnt
private-bin atomicparsley,ffmpeg,ffprobe,python*,youtube-dl-gui
private-cache
private-dev
private-etc alternatives,ca-certificates,crypto-policies,dconf,fonts,gtk-2.0,gtk-3.0,hostname,hosts,ld.so.cache,locale,locale.conf,passwd,pki,resolv.conf,ssl
rivate-tmp

dbus-user none
dbus-system none

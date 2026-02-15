# Firejail profile for yt-dlp
# Description: Downloader of videos of various sites
# This file is overwritten after every install/update
quiet
# Persistent local customizations
include yt-dlp.local
# Persistent global definitions
include globals.local

# If you installed via pip under ${HOME}
# add 'ignore noexec ${HOME}' in yt-dlp.local.
# AppArmor needs to allow it too,
# add 'ignore apparmor' in yt-dlp.local
# OR in /etc/apparmor.d/local/firejail-default add:
# 'owner @HOME/.local/bin/** ix,'
# 'owner @HOME/.local/lib/python*/** ix,'
# then run the command
# 'sudo apparmor_parser -r /etc/apparmor.d/firejail-default'

# For age-restricted and rate-limited videos, uncomment the following line
# (yt-dlp needs the browser cookie):
#noblacklist ${HOME}/.config/mozilla
#noblacklist ${HOME}/.mozilla

noblacklist ${PATH}/deno

noblacklist ${HOME}/.cache/yt-dlp
noblacklist ${HOME}/.config/yt-dlp
noblacklist ${HOME}/.config/yt-dlp.conf
noblacklist ${HOME}/.deno
noblacklist ${HOME}/.netrc
noblacklist ${HOME}/yt-dlp.conf
noblacklist ${HOME}/yt-dlp.conf.txt
noblacklist ${MUSIC}
noblacklist ${VIDEOS}

# Allow python (blacklisted by disable-interpreters.inc)
include allow-python3.inc

blacklist ${RUNUSER}

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-programs.inc
include disable-shell.inc
include disable-x11.inc
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
tracelog

private-bin deno,env,ffmpeg,ffprobe,file,python*,uname,yt-dlp
private-cache
private-dev
private-etc @tls-ca,mime.types,yt-dlp,yt-dlp-plugins,yt-dlp.conf
private-tmp

dbus-user none
dbus-system none

# breaks deno JavaScript
#memory-deny-write-execute

restrict-namespaces

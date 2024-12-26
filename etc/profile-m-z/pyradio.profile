quiet
# Persistent local customizations
include pyradio.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.config/mpv
noblacklist ${HOME}/.netrc
noblacklist ${HOME}/.mplayer
noblacklist ${HOME}/.cache/vlc
noblacklist ${HOME}/.config/vlc
noblacklist ${HOME}/.config/aacs
noblacklist ${HOME}/.local/share/vlc

# This is required by mpv
include allow-lua.inc

include allow-python3.inc

blacklist ${RUNUSER}/wayland-*
blacklist /usr/libexec

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-proc.inc
include disable-programs.inc
include disable-shell.inc
include disable-X11.inc
include disable-xdg.inc

mkdir ${HOME}/.config/pyradio
mkdir ${HOME}/.cache/pyradio
mkdir ${HOME}/.local/share/pyradio
mkdir ${HOME}/.local/state/pyradio
mkdir ${HOME}/pyradio-recordings
whitelist ${HOME}/.config/pyradio
whitelist ${HOME}/.cache/pyradio
whitelist ${HOME}/.local/share/pyradio
whitelist ${HOME}/.local/state/pyradio
whitelist ${HOME}/pyradio-recordings
# mpv
mkdir ${HOME}/.config/mpv
mkfile ${HOME}/.netrc
whitelist ${HOME}/.config/mpv
whitelist ${HOME}/.netrc
whitelist /usr/share/lua
whitelist /usr/share/lua*
# mplayer
mkdir ${HOME}/.mplayer
whitelist ${HOME}/.mplayer
# vlc
mkdir ${HOME}/.cache/vlc
mkdir ${HOME}/.config/vlc
mkdir ${HOME}/.local/share/vlc
whitelist ${HOME}/.cache/vlc
whitelist ${HOME}/.config/vlc
whitelist ${HOME}/.local/share/vlc
whitelist ${HOME}/.config/aacs

include whitelist-common.inc
include whitelist-run-common.inc
include whitelist-runuser-common.inc
include whitelist-usr-share-common.inc
include whitelist-var-common.inc

apparmor
caps.drop all
ipc-namespace
netfilter
no3d
nodvd
nogroups
noinput
nonewprivs
noprinters
noroot
notv
nou2f
novideo
protocol unix,inet,inet6,netlink
seccomp
seccomp.block-secondary
tracelog

disable-mnt
private-dev
private-tmp

writable-run-user

dbus-user none
dbus-system none

deterministic-shutdown
#memory-deny-write-execute crashes lua
read-write ${HOME}
restrict-namespaces

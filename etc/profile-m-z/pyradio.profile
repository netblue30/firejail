# Firejail profile for pyradio
# Description: Curses based internet radio player
# This file is overwritten after every install/update
quiet
# Persistent local customizations
include pyradio.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.cache/mpv
noblacklist ${HOME}/.cache/vlc
noblacklist ${HOME}/.config/mpv
noblacklist ${HOME}/.config/vlc
noblacklist ${HOME}/.local/share/vlc
noblacklist ${HOME}/.local/state/mpv
noblacklist ${HOME}/.mplayer

noblacklist ${HOME}/.cache/pyradio
noblacklist ${HOME}/.config/pyradio
noblacklist ${HOME}/.local/share/pyradio
noblacklist ${HOME}/.local/state/pyradio
noblacklist ${HOME}/pyradio-recordings

# Lua is required by mpv.
# Allow lua (blacklisted by disable-interpreters.inc)
include allow-lua.inc

# Allow python (blacklisted by disable-interpreters.inc)
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

whitelist ${HOME}/.cache/mpv
whitelist ${HOME}/.cache/vlc
whitelist ${HOME}/.config/mpv
whitelist ${HOME}/.config/vlc
whitelist ${HOME}/.local/share/vlc
whitelist ${HOME}/.local/state/mpv
whitelist ${HOME}/.mplayer
whitelist ${HOME}/.netrc
whitelist /usr/share/lua*
whitelist /usr/share/mpv
whitelist /usr/share/vlc

mkdir ${HOME}/.cache/pyradio
mkdir ${HOME}/.config/pyradio
mkdir ${HOME}/.local/share/pyradio
mkdir ${HOME}/.local/state/pyradio
mkdir ${HOME}/pyradio-recordings
whitelist ${HOME}/.cache/pyradio
whitelist ${HOME}/.config/pyradio
whitelist ${HOME}/.local/share/pyradio
whitelist ${HOME}/.local/state/pyradio
whitelist ${HOME}/pyradio-recordings
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
notpm
notv
nou2f
novideo
protocol unix,inet,inet6,netlink
seccomp
seccomp.block-secondary

disable-mnt
private-dev
# python-exec is required by any python executable on Gentoo Linux
private-etc @sound,@tls-ca,mplayer,mpv,python-exec,terminfo
private-tmp
writable-run-user

dbus-user none
dbus-system none

deterministic-shutdown
#memory-deny-write-execute # crashes lua
restrict-namespaces

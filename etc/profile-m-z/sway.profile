# Firejail profile for Sway
# Description: i3-compatible Wayland compositor
# This file is overwritten after every install/update
# Persistent local customizations
include sway.local
# Persistent global definitions
include globals.local

# all applications started in sway will run in this profile
noblacklist ${HOME}/.config/sway
# sway uses ~/.config/i3 as fallback if there is no ~/.config/sway
noblacklist ${HOME}/.config/i3
# allow creation of IPC socket
noblacklist ${RUNUSER}/sway-ipc.*
noblacklist /tmp/sway-ipc.*

include disable-common.inc

caps.drop all
netfilter
noroot
protocol unix,inet,inet6
seccomp

restrict-namespaces

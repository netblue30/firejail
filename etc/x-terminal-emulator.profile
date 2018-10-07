# Firejail profile for x-terminal-emulator
# This file is overwritten after every install/update
# Persistent local customizations
include /etc/firejail/x-terminal-emulator.local
# Persistent global definitions
include /etc/firejail/globals.local

caps.drop all
ipc-namespace
net none
netfilter
nodbus
nogroups
noroot
protocol unix
seccomp

private-dev

noexec /tmp

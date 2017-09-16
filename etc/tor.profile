# Firejail profile for tor
# This file is overwritten after every install/update
# Persistent local customizations
include /etc/firejail/tor.local
# Persistent global definitions
include /etc/firejail/globals.local

# How to use:
# Create a script called anything (e.g. mytor)
# with the following contents:
# #!/bin/bash
# TORCMD="tor --defaults-torrc /usr/share/tor/tor-service-defaults-torrc -f /etc/tor/torrc --RunAsDaemon 1"
# sudo -b daemon -f -d -- firejail --profile=/home/<username>/.config/firejail/tor.profile $TORCMD

# You'll also likely want to disable the system service (if it exists)
# Run mytor (or whatever you called the script above) whenever you want to start tor

blacklist /boot
blacklist /media
blacklist /mnt
blacklist /opt

caps.keep setuid,setgid,net_bind_service,dac_read_search
ipc-namespace
no3d
nogroups
nonewprivs
nosound
seccomp
shell none
writable-var
x11 none

private
private-bin tor,bash
private-dev
private-etc tor,passwd
private-tmp

# Firejail profile for openbox
# This file is overwritten after every install/update
# Persistent local customizations
include /etc/firejail/openbox.local
# Persistent global definitions
include /etc/firejail/globals.local

# all applications started in OpenBox will run in this profile
noblacklist ${HOME}/.config/openbox
include /etc/firejail/disable-common.inc

caps.drop all
netfilter
noroot
protocol unix,inet,inet6
seccomp

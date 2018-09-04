# Firejail profile for fluxbox
# Description: Standards-compliant, fast, light-weight and extensible window manager
# This file is overwritten after every install/update
# Persistent local customizations
include /etc/firejail/fluxbox.local
# Persistent global definitions
include /etc/firejail/globals.local

# all applications started in awesome will run in this profile
noblacklist ${HOME}/.fluxbox
include /etc/firejail/disable-common.inc

caps.drop all
netfilter
noroot
protocol unix,inet,inet6
seccomp


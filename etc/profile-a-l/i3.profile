# Firejail profile for i3
# Description: Standards-compliant, fast, light-weight and extensible window manager
# This file is overwritten after every install/update
# Persistent local customizations
include i3.local
# Persistent global definitions
include globals.local

# all applications started in i3 will run in this profile
noblacklist ${HOME}/.config/i3
include disable-common.inc

caps.drop all
netfilter
noroot
protocol unix,inet,inet6
seccomp

restrict-namespaces

# Firejail profile for openbox
# Description: Standards-compliant, fast, light-weight and extensible window manager
# This file is overwritten after every install/update
# Persistent local customizations
include openbox.local
# Persistent global definitions
include globals.local

# all applications started in openbox will run in this profile
noblacklist ${HOME}/.config/openbox
include disable-common.inc

caps.drop all
netfilter
noroot
protocol unix,inet,inet6
seccomp !chroot

read-only ${HOME}/.config/openbox/autostart
read-only ${HOME}/.config/openbox/environment
#restrict-namespaces

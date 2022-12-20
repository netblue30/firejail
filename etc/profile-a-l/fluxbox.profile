# Firejail profile for fluxbox
# Description: Standards-compliant, fast, light-weight and extensible window manager
# This file is overwritten after every install/update
# Persistent local customizations
include fluxbox.local
# Persistent global definitions
include globals.local

# all applications started in fluxbox will run in this profile
noblacklist ${HOME}/.fluxbox
include disable-common.inc

caps.drop all
netfilter
noroot
protocol unix,inet,inet6
seccomp

restrict-namespaces

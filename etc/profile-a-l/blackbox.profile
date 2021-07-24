# Firejail profile for blackbox
# Description: Standards-compliant, fast, light-weight and extensible window manager
# This file is overwritten after every install/update
# Persistent local customizations
include blackbox.local
# Persistent global definitions
include globals.local

# all applications started in blackbox will run in this profile
nodeny  ${HOME}/.blackbox
include disable-common.inc

caps.drop all
netfilter
noroot
protocol unix,inet,inet6
seccomp


# Firejail profile for blender
# Description: Very fast and versatile 3D modeller/renderer
# This file is overwritten after every install/update
# Persistent local customizations
include blender.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.config/blender

# Allow python (blacklisted by disable-interpreters.inc)
include allow-python2.inc
include allow-python3.inc

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc

# Allow usage of AMD GPU by OpenCL
noblacklist /sys/module
whitelist /sys/module/amdgpu
read-only /sys/module/amdgpu

caps.drop all
netfilter
nodvd
nogroups
noinput
nonewprivs
noroot
notv
nou2f
protocol unix,inet,inet6,netlink
# numpy, used by many add-ons, requires the mbind syscall
seccomp !mbind
shell none

private-dev

# Firejail profile for baloo_file
# This file is overwritten after every install/update
# Persistent local customizations
include baloo_file.local
# Persistent global definitions
include globals.local

# Make home directory read-only and allow writing only to ${HOME}/.local/share/baloo
# Note: Baloo will not be able to update the "first run" key in its configuration files.
#mkdir ${HOME}/.local/share/baloo
#read-only ${HOME}
#read-write ${HOME}/.local/share/baloo
#ignore read-write

noblacklist ${HOME}/.config/baloofilerc
noblacklist ${HOME}/.kde/share/config/baloofilerc
noblacklist ${HOME}/.kde/share/config/baloorc
noblacklist ${HOME}/.kde4/share/config/baloofilerc
noblacklist ${HOME}/.kde4/share/config/baloorc
noblacklist ${HOME}/.local/share/baloo

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-programs.inc

include whitelist-run-common.inc
include whitelist-var-common.inc

apparmor
caps.drop all
machine-id
#net none
netfilter
no3d
nodvd
nogroups
noinput
nonewprivs
noroot
nosound
notv
nou2f
novideo
protocol unix
# blacklisting of ioprio_set system calls breaks baloo_file
seccomp !ioprio_set
#x11 xorg

private-bin baloo_file,baloo_file_extractor,baloo_filemetadata_temp_extractor,kbuildsycoca4
private-cache
private-dev
private-tmp

restrict-namespaces

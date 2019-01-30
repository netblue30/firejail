# Firejail profile for baloo_file
# This file is overwritten after every install/update
# Persistent local customizations
include baloo_file.local
# Persistent global definitions
include globals.local

# Make home directory read-only and allow writing only to ${HOME}/.local/share
# Note: Baloo will not be able to update the "first run" key in its configuration files.
# read-only  ${HOME}
# read-write ${HOME}/.local/share

noblacklist ${HOME}/.config/baloofilerc
noblacklist ${HOME}/.kde/share/config/baloofilerc
noblacklist ${HOME}/.kde/share/config/baloorc
noblacklist ${HOME}/.kde4/share/config/baloofilerc
noblacklist ${HOME}/.kde4/share/config/baloorc
noblacklist ${HOME}/.local/share/baloo

include disable-common.inc
include disable-devel.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc

include whitelist-var-common.inc

caps.drop all
netfilter
no3d
nodvd
nogroups
nonewprivs
noroot
nosound
notv
nou2f
novideo
protocol unix
# blacklisting of ioprio_set system calls breaks baloo_file
seccomp.drop @cpu-emulation,@debug,@obsolete,@privileged,@resources,add_key,fanotify_init,io_cancel,io_destroy,io_getevents,io_setup,io_submit,kcmp,keyctl,name_to_handle_at,ni_syscall,open_by_handle_at,personality,process_vm_readv,ptrace,remap_file_pages,request_key,syslog,umount,userfaultfd,vmsplice
shell none
# x11 xorg

private-cache
private-bin baloo_file,baloo_file_extractor,baloo_filemetadata_temp_extractor,kbuildsycoca4
private-dev
private-tmp

noexec ${HOME}
noexec /tmp

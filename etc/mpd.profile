# Firejail profile for mpd
# Description: Music Player Daemon
# This file is overwritten after every install/update
# Persistent local customizations
include mpd.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.config/mpd
noblacklist ${HOME}/.mpd
noblacklist ${HOME}/.mpdconf
noblacklist ${MUSIC}

include disable-common.inc
include disable-devel.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc
include disable-xdg.inc

caps.drop all
netfilter
no3d
nodvd
nonewprivs
noroot
notv
nou2f
novideo
protocol unix,inet,inet6
# blacklisting of ioprio_set system calls breaks auto-updating of
# MPD's database when files in music_directory are changed
seccomp.drop @cpu-emulation,@debug,@obsolete,@privileged,@resources,add_key,fanotify_init,io_cancel,io_destroy,io_getevents,io_setup,io_submit,kcmp,keyctl,name_to_handle_at,ni_syscall,open_by_handle_at,personality,process_vm_readv,ptrace,remap_file_pages,request_key,syslog,umount,userfaultfd,vmsplice
shell none

#private-bin mpd,bash
private-cache
private-dev
private-tmp

noexec ${HOME}
noexec /tmp

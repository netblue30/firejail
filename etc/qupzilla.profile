# Firejail profile for qupzilla
# This file is overwritten after every install/update
# Persistent local customizations
include /etc/firejail/qupzilla.local
# Persistent global definitions
include /etc/firejail/globals.local

noblacklist ${HOME}/.cache/qupzilla
noblacklist ${HOME}/.config/qupzilla

include /etc/firejail/disable-common.inc
include /etc/firejail/disable-devel.inc
include /etc/firejail/disable-interpreters.inc
include /etc/firejail/disable-passwdmgr.inc
include /etc/firejail/disable-programs.inc

whitelist ${DOWNLOADS}
whitelist ${HOME}/.cache/qupzilla
whitelist ${HOME}/.config/qupzilla
include /etc/firejail/whitelist-common.inc
include /etc/firejail/whitelist-var-common.inc

caps.drop all
netfilter
nodvd
nogroups
nonewprivs
noroot
notv
protocol unix,inet,inet6,netlink
# blacklisting of chroot system calls breaks qupzilla
seccomp.drop @clock,@cpu-emulation,@debug,@module,@obsolete,@raw-io,@reboot,@resources,@swap,acct,add_key,bpf,fanotify_init,io_cancel,io_destroy,io_getevents,io_setup,io_submit,ioprio_set,kcmp,keyctl,mount,name_to_handle_at,nfsservctl,ni_syscall,open_by_handle_at,personality,pivot_root,process_vm_readv,ptrace,remap_file_pages,request_key,setdomainname,sethostname,syslog,umount,umount2,userfaultfd,vhangup,vmsplice
# tracelog

private-dev
# private-etc passwd,group,hostname,hosts,localtime,nsswitch.conf,resolv.conf,gtk-2.0,pango,fonts,adobe,mime.types,mailcap,asound.conf,pulse,machine-id,ca-certificates,ssl,pki,crypto-policies
# private-tmp - interferes with the opening of downloaded files

noexec ${HOME}
noexec /tmp

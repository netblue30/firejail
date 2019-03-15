# Firejail profile for start-tor-browser
# This file is overwritten after every install/update
# Persistent local customizations
include start-tor-browser.local
# Persistent global definitions
include globals.local

ignore noexec ${HOME}

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc
include disable-xdg.inc

include whitelist-var-common.inc

caps.drop all
netfilter
nodbus
nodvd
nogroups
nonewprivs
noroot
notv
nou2f
novideo
protocol unix,inet,inet6
seccomp.drop @clock,@cpu-emulation,@debug,@module,@obsolete,@raw-io,@reboot,@resources,@swap,acct,add_key,bpf,fanotify_init,io_cancel,io_destroy,io_getevents,io_setup,io_submit,ioprio_set,kcmp,keyctl,mount,name_to_handle_at,nfsservctl,ni_syscall,open_by_handle_at,personality,pivot_root,process_vm_readv,ptrace,remap_file_pages,request_key,setdomainname,sethostname,syslog,umount,umount2,userfaultfd,vhangup,vmsplice
shell none
# tracelog may cause issues, see github issue #1930
#tracelog

disable-mnt
private-bin bash,sh,grep,tail,env,gpg,id,readlink,dirname,test,mkdir,ln,sed,cp,rm,getconf
private-dev
private-etc alternatives,fonts,hostname,hosts,resolv.conf,pki,ssl,ca-certificates,crypto-policies,alsa,asound.conf,pulse,machine-id,ld.so.cache
private-tmp

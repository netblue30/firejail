# Firejail profile for bibletime
# Description: Bible study tool
# This file is overwritten after every install/update
# Persistent local customizations
include bibletime.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.bibletime
noblacklist ${HOME}/.sword
noblacklist ${HOME}/.local/share/bibletime

blacklist ${HOME}/.bashrc

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc

mkdir ${HOME}/.bibletime
mkdir ${HOME}/.sword
mkdir ${HOME}/.local/share/bibletime
whitelist ${HOME}/.bibletime
whitelist ${HOME}/.sword
whitelist ${HOME}/.local/share/bibletime
include whitelist-common.inc
include whitelist-var-common.inc

apparmor
caps.drop all
machine-id
netfilter
nodbus
nodvd
nogroups
nonewprivs
noroot
nosound
notv
nou2f
novideo
protocol unix,inet,inet6,netlink
seccomp.drop @clock,@cpu-emulation,@debug,@module,@obsolete,@raw-io,@reboot,@resources,@swap,acct,add_key,bpf,fanotify_init,io_cancel,io_destroy,io_getevents,io_setup,io_submit,ioprio_set,kcmp,keyctl,mount,name_to_handle_at,nfsservctl,ni_syscall,open_by_handle_at,personality,pivot_root,process_vm_readv,ptrace,remap_file_pages,request_key,setdomainname,sethostname,syslog,umount,umount2,userfaultfd,vhangup,vmsplice
shell none

disable-mnt
# private-bin bibletime,qt5ct
private-cache
private-dev
private-etc alternatives,ca-certificates,crypto-policies,fonts,login.defs,machine-id,passwd,pki,resolv.conf,ssl,sword,sword.conf
private-tmp

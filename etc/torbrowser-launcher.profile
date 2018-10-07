# Firejail profile for torbrowser-launcher
# Description: Helps download and run the Tor Browser Bundle
# This file is overwritten after every install/update
# Persistent local customizations
include /etc/firejail/torbrowser-launcher.local
# Persistent global definitions
include /etc/firejail/globals.local

noblacklist ${HOME}/.config/torbrowser
noblacklist ${HOME}/.local/share/torbrowser

# Allow python (blacklisted by disable-interpreters.inc)
noblacklist ${PATH}/python2*
noblacklist ${PATH}/python3*
noblacklist /usr/lib/python2*
noblacklist /usr/lib/python3*

include /etc/firejail/disable-common.inc
include /etc/firejail/disable-devel.inc
include /etc/firejail/disable-interpreters.inc
include /etc/firejail/disable-passwdmgr.inc
include /etc/firejail/disable-programs.inc
include /etc/firejail/disable-xdg.inc

mkdir ${HOME}/.config/torbrowser
mkdir ${HOME}/.local/share/torbrowser
whitelist ${DOWNLOADS}
whitelist ${HOME}/.config/torbrowser
whitelist ${HOME}/.local/share/torbrowser
include /etc/firejail/whitelist-common.inc
include /etc/firejail/whitelist-var-common.inc

caps.drop all
netfilter
nodbus
nodvd
nogroups
nonewprivs
noroot
notv
novideo
protocol unix,inet,inet6
seccomp.drop @clock,@cpu-emulation,@debug,@module,@obsolete,@raw-io,@reboot,@resources,@swap,acct,add_key,bpf,fanotify_init,io_cancel,io_destroy,io_getevents,io_setup,io_submit,ioprio_set,kcmp,keyctl,mount,name_to_handle_at,nfsservctl,ni_syscall,open_by_handle_at,personality,pivot_root,process_vm_readv,ptrace,remap_file_pages,request_key,setdomainname,sethostname,syslog,umount,umount2,userfaultfd,vhangup,vmsplice
shell none
# tracelog may cause issues, see github issue #1930
#tracelog

disable-mnt
private-bin bash,cp,dirname,env,expr,file,getconf,gpg,grep,id,ln,mkdir,python*,readlink,rm,sed,sh,tail,tar,tclsh,test,tor-browser-en,torbrowser-launcher,xz
private-dev
private-etc fonts,hostname,hosts,resolv.conf,pki,ssl,ca-certificates,crypto-policies,alsa,asound.conf,pulse,machine-id,ld.so.cache
private-tmp

noexec /tmp

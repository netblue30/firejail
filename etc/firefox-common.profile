# Firejail profile for firefox-common
# This file is overwritten after every install/update
# Persistent local customizations
include firefox-common.local
# Persistent global definitions
# already included by caller profile
#include globals.local

# uncomment the following line to allow access to common programs/addons/plugins
#include firefox-common-addons.inc

noblacklist ${HOME}/.pki
noblacklist ${HOME}/.local/share/pki

include disable-common.inc
include disable-devel.inc
include disable-interpreters.inc
include disable-programs.inc

mkdir ${HOME}/.pki
mkdir ${HOME}/.local/share/pki
whitelist ${DOWNLOADS}
whitelist ${HOME}/.pki
whitelist ${HOME}/.local/share/pki
include whitelist-common.inc
include whitelist-var-common.inc

apparmor
caps.drop all
# machine-id breaks pulse audio; it should work fine in setups where sound is not required
#machine-id
netfilter
# Breaks Gnome connector and KDE Connect
# Also seems to break Ubuntu titlebar menu
# Also breaks enigmail apparently?
# During a stream on Plasma it prevents the mechanism to temporarily bypass the power management, i.e. to keep the screen on
# Therefore disable if you use that
nodbus
nodvd
nogroups
nonewprivs
noroot
notv
?BROWSER_DISABLE_U2F: nou2f
protocol unix,inet,inet6,netlink
seccomp.drop @clock,@cpu-emulation,@debug,@module,@obsolete,@raw-io,@reboot,@resources,@swap,acct,add_key,bpf,fanotify_init,io_cancel,io_destroy,io_getevents,io_setup,io_submit,ioprio_set,kcmp,keyctl,mount,name_to_handle_at,nfsservctl,ni_syscall,open_by_handle_at,personality,pivot_root,process_vm_readv,ptrace,remap_file_pages,request_key,setdomainname,sethostname,syslog,umount,umount2,userfaultfd,vhangup,vmsplice
shell none
#disable tracelog, it breaks or causes major issues with many firefox based browsers, see github issue #1930
#tracelog

disable-mnt
private-dev
# private-etc below works fine on most distributions. There are some problems on CentOS.
#private-etc ca-certificates,ssl,machine-id,dconf,selinux,passwd,group,hostname,hosts,localtime,nsswitch.conf,resolv.conf,xdg,gtk-2.0,gtk-3.0,X11,pango,fonts,mime.types,mailcap,asound.conf,pulse,pki,crypto-policies,ld.so.cache
private-tmp

# breaks DRM binaries
#noexec ${HOME}
noexec /tmp

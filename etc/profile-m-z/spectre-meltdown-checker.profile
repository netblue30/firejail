# Firejail profile for spectre-meltdown-checker
# This file is overwritten after every install/update
quiet
# Persistent local customizations
include spectre-meltdown-checker.local
# Persistent global definitions
include globals.local

blacklist ${RUNUSER}/wayland-*

noblacklist ${PATH}/mount
noblacklist ${PATH}/umount
noblacklist /proc/config.gz

# Allow perl (blacklisted by disable-interpreters.inc)
include allow-perl.inc

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-programs.inc
include disable-xdg.inc

include whitelist-usr-share-common.inc
include whitelist-var-common.inc

allow-debuggers
caps.keep sys_rawio
ipc-namespace
net none
no3d
nodvd
nogroups
nonewprivs
nosound
notv
novideo
protocol unix
seccomp.drop @clock,@cpu-emulation,@module,@obsolete,@reboot,@resources,@swap
x11 none

disable-mnt
private
private-bin awk,basename,bzip2,cat,coreos-install,cpucontrol,cut,dd,dirname,dmesg,dnf,echo,grep,gunzip,gz,gzip,head,id,kldload,kldstat,liblz4-tool,lzop,mktemp,modinfo,modprobe,mount,nm,objdump,od,perl,printf,ps,readelf,rm,sed,seq,sh,sort,spectre-meltdown-checker,spectre-meltdown-checker.sh,stat,strings,sysctl,tail,test,toolbox,tr,uname,unzstd,which,xz-utils
private-cache
private-tmp

dbus-user none
dbus-system none

memory-deny-write-execute
restrict-namespaces

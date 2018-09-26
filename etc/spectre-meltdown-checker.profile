# Firejail profile for spectre-meltdown-checker
# This file is overwritten after every install/update
quiet
# Persistent local customizations
include /etc/firejail/spectre-meltdown-checker.local
# Persistent global definitions
include /etc/firejail/globals.local

# sudo firejail --allow-debuggers spectre-meltdown-checker

noblacklist ${PATH}/mount
noblacklist ${PATH}/umount

# Allow access to perl
noblacklist ${PATH}/cpan*
noblacklist ${PATH}/core_perl
noblacklist ${PATH}/perl
noblacklist /usr/lib/perl*
noblacklist /usr/share/perl*

include /etc/firejail/disable-common.inc
include /etc/firejail/disable-devel.inc
include /etc/firejail/disable-interpreters.inc
include /etc/firejail/disable-passwdmgr.inc
include /etc/firejail/disable-programs.inc
include /etc/firejail/disable-xdg.inc

include /etc/firejail/whitelist-var-common.inc

caps.keep sys_rawio
ipc-namespace
net none
no3d
nodbus
nodvd
nogroups
nonewprivs
nosound
notv
novideo
protocol unix
seccomp.drop @clock,@cpu-emulation,@module,@obsolete,@reboot,@resources,@swap
shell none

disable-mnt
private
private-bin awk,bzip2,cat,coreos-install,cpucontrol,cut,dd,dmesg,dnf,echo,grep,gunzip,gz,gzip,head,id,kldload,kldstat,liblz4-tool,lzop,mktemp,modinfo,modprobe,mount,nm,objdump,od,perl,printf,readelf,rm,sed,seq,sh,sort,spectre-meltdown-checker,spectre-meltdown-checker.sh,stat,strings,sysctl,tail,test,toolbox,tr,uname,which,xz-utils
private-cache
private-tmp

memory-deny-write-execute
noexec ${HOME}
noexec /tmp

# Firejail profile for file-roller
# Description: Archive manager for GNOME
# This file is overwritten after every install/update
# Persistent local customizations
include file-roller.local
# Persistent global definitions
include globals.local

noblacklist ${PATH}/dpkg*

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-programs.inc

whitelist /usr/libexec/file-roller
whitelist /usr/libexec/p7zip
whitelist /usr/share/file-roller
include whitelist-runuser-common.inc
include whitelist-usr-share-common.inc
include whitelist-var-common.inc

apparmor
caps.drop all
machine-id
#net none # breaks on older Ubuntu versions
netfilter
no3d
nodvd
nogroups
noinput
nonewprivs
noprinters
noroot
nosound
notv
nou2f
novideo
protocol unix
seccomp
seccomp.block-secondary
tracelog

private-bin 7z,7za,7zr,ar,arj,atool,bash,brotli,bsdtar,bzip2,compress,cp,cpio,dpkg*,file-roller,gtar,gzip,isoinfo,lha,lrzip,lsar,lz4,lzip,lzma,lzop,mv,p7zip,rar,rm,rzip,sh,tar,unace,unalz,unar,uncompress,unrar,unsquashfs,unstuff,unzip,unzstd,xz,xzdec,zip,zoo,zstd
private-cache
private-dev
private-etc @x11
#private-tmp

dbus-user filter
dbus-user.own org.gnome.ArchiveManager1
dbus-user.own org.gnome.FileRoller
dbus-user.talk ca.desrt.dconf
dbus-system none

restrict-namespaces

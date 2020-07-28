# Firejail profile for file-roller
# Description: Archive manager for GNOME
# This file is overwritten after every install/update
# Persistent local customizations
include file-roller.local
# Persistent global definitions
include globals.local

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc

whitelist /usr/share/file-roller
include whitelist-runuser-common.inc
include whitelist-usr-share-common.inc
include whitelist-var-common.inc

apparmor
caps.drop all
#ipc-namespace - causing issues launching on archlinux
machine-id
# net none - breaks on older Ubuntu versions
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
seccomp
shell none
tracelog

private-bin 7z,7za,7zr,ar,arj,bash,brotli,bzip2,compress,cpio,dpkg-deb,file-roller,gtar,gzip,isoinfo,lha,lrzip,lsar,lz4,lzip,lzma,lzop,p7zip,rar,rzip,sh,tar,unace,unalz,unar,uncompress,unrar,unsquashfs,unstuff,unzip,xz,zip,zoo
private-cache
private-dev
private-etc dconf,fonts,gtk-3.0,xdg
# private-tmp

dbus-system none

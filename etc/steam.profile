# Firejail profile for steam
# Description: Valve's Steam digital software delivery system
# This file is overwritten after every install/update
# Persistent local customizations
include /etc/firejail/steam.local
# Persistent global definitions
include /etc/firejail/globals.local

noblacklist ${HOME}/.java
noblacklist ${HOME}/.killingfloor
noblacklist ${HOME}/.local/share/3909/PapersPlease
noblacklist ${HOME}/.local/share/aspyr-media
noblacklist ${HOME}/.local/share/cdprojektred
noblacklist ${HOME}/.local/share/feral-interactive
noblacklist ${HOME}/.local/share/Steam
noblacklist ${HOME}/.local/share/SuperHexagon
noblacklist ${HOME}/.local/share/Terraria
noblacklist ${HOME}/.local/share/vpltd
noblacklist ${HOME}/.local/share/vulkan
noblacklist ${HOME}/.steam
noblacklist ${HOME}/.steampath
noblacklist ${HOME}/.steampid
# with >=llvm-4 mesa drivers need llvm stuff
noblacklist /usr/lib/llvm*
# needed for STEAM_RUNTIME_PREFER_HOST_LIBRARIES=1 to work
noblacklist /sbin

# Allow access to java
noblacklist ${PATH}/java
noblacklist /usr/lib/java
noblacklist /etc/java
noblacklist /usr/share/java

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

include /etc/firejail/whitelist-var-common.inc

caps.drop all
#ipc-namespace
netfilter
# nodbus disabled as it breaks appindicator support
#nodbus
nodvd
nogroups
nonewprivs
noroot
notv
# novideo should be commented for VR
novideo
protocol unix,inet,inet6,netlink
seccomp
shell none
# tracelog disabled as it breaks integrated browser
#tracelog

# private-bin is disabled while in testing, but has been tested working with multiple games
#private-bin awk,basename,bash,bsdtar,bzip2,cat,chmod,cksum,cmp,comm,compress,cp,curl,cut,date,dbus-launch,dbus-send,desktop-file-edit,desktop-file-install,desktop-file-validate,dirname,echo,env,expr,file,find,getopt,grep,gtar,gzip,head,hostname,id,lbzip2,ldconfig,ldd,ln,ls,lsb_release,lspci,lsof,lz4,lzip,lzma,lzop,md5sum,mkdir,mktemp,mv,netstat,ps,pulseaudio,python*,readlink,realpath,rm,sed,sh,sha1sum,sha256sum,sha512sum,sleep,sort,steam,steamdeps,steam-native,steam-runtime,sum,tail,tar,test,touch,tr,umask,uname,update-desktop-database,wc,wget,which,whoami,xterm,xz,zenity
# extra programs are available which might be needed for select games
#private-bin java,java-config,mono
# picture viewers are needed for viewing screenshots
#private-bin eog,eom,gthumb,pix,viewnior,xviewer

# private-dev should be commented for controllers
private-dev
# private-etc breaks a small selection of games on some systems, comment to support those
private-etc asound.conf,ca-certificates,dbus-1,drirc,fonts,group,gtk-2.0,gtk-3.0,host.conf,hostname,hosts,ld.so.cache,ld.so.preload,ld.so.conf,ld.so.conf.d,localtime,lsb-release,machine-id,mime.types,passwd,pulse,resolv.conf,ssl,pki,services,crypto-policies,alternatives,bumblebee,nvidia,os-release
private-tmp

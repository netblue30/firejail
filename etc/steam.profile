# Firejail profile for steam
# Description: Valve's Steam digital software delivery system
# This file is overwritten after every install/update
# Persistent local customizations
include steam.local
# Persistent global definitions
include globals.local

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
# needed for STEAM_RUNTIME_PREFER_HOST_LIBRARIES=1 to work
noblacklist /sbin
noblacklist /usr/sbin

# Allow java (blacklisted by disable-devel.inc)
include allow-java.inc

# Allow python (blacklisted by disable-interpreters.inc)
include	allow-python2.inc
include	allow-python3.inc

include disable-common.inc
include disable-devel.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc

include whitelist-var-common.inc

# allow-debuggers needed for running some games with proton
allow-debuggers
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
nou2f
# novideo should be commented for VR
novideo
protocol unix,inet,inet6,netlink
# seccomp cause sometimes issues (see #2860, #2951),
# comment it or add 'ignore seccomp' to steam.local if so.
seccomp
shell none
# tracelog disabled as it breaks integrated browser
#tracelog

# private-bin is disabled while in testing, but has been tested working with multiple games
#private-bin awk,basename,bash,bsdtar,bzip2,cat,chmod,cksum,cmp,comm,compress,cp,curl,cut,date,dbus-launch,dbus-send,desktop-file-edit,desktop-file-install,desktop-file-validate,dirname,echo,env,expr,file,find,getopt,grep,gtar,gzip,head,hostname,id,lbzip2,ldconfig,ldd,ln,ls,lsb_release,lsof,lspci,lz4,lzip,lzma,lzop,md5sum,mkdir,mktemp,mv,netstat,ps,pulseaudio,python*,readlink,realpath,rm,sed,sh,sha1sum,sha256sum,sha512sum,sleep,sort,steam,steamdeps,steam-native,steam-runtime,sum,tail,tar,tclsh,test,touch,tr,umask,uname,update-desktop-database,wc,wget,which,whoami,xterm,xz,zenity
# extra programs are available which might be needed for select games
#private-bin java,java-config,mono
# picture viewers are needed for viewing screenshots
#private-bin eog,eom,gthumb,pix,viewnior,xviewer

# private-dev should be commented for controllers
private-etc Trolltech.conf,X11,alsa,alternatives,asound.conf,bumblebee,ca-certificates,crypto-policies,dbus-1,dconf,drirc,fonts,gconf,glvnd,gtk-2.0,gtk-3.0,hosts,host.conf,hostname,java.conf,java-10-openjdk,java-9-openjdk,java-8-openjdk,java-7-openjdk,ld.so.cache,ld.so.preload,ld.so.conf,ld.so.conf.d,locale,locale.alias,locale.conf,localtime,lsb-release,machine-id,mime.types,mono,nsswitch.conf,pango,passwd,pki,protocols,pulse,resolv.conf,rpc,services,ssl,xdg
private-dev
private-tmp

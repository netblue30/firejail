# Firejail profile for steam
# Description: Valve's Steam digital software delivery system
# This file is overwritten after every install/update
# Persistent local customizations
include steam.local
# Persistent global definitions
include globals.local

nodeny  ${HOME}/.config/Epic
nodeny  ${HOME}/.config/Loop_Hero
nodeny  ${HOME}/.config/ModTheSpire
nodeny  ${HOME}/.config/RogueLegacy
nodeny  ${HOME}/.config/RogueLegacyStorageContainer
nodeny  ${HOME}/.killingfloor
nodeny  ${HOME}/.klei
nodeny  ${HOME}/.local/share/3909/PapersPlease
nodeny  ${HOME}/.local/share/aspyr-media
nodeny  ${HOME}/.local/share/bohemiainteractive
nodeny  ${HOME}/.local/share/cdprojektred
nodeny  ${HOME}/.local/share/Dredmor
nodeny  ${HOME}/.local/share/FasterThanLight
nodeny  ${HOME}/.local/share/feral-interactive
nodeny  ${HOME}/.local/share/IntoTheBreach
nodeny  ${HOME}/.local/share/Paradox Interactive
nodeny  ${HOME}/.local/share/PillarsOfEternity
nodeny  ${HOME}/.local/share/RogueLegacy
nodeny  ${HOME}/.local/share/RogueLegacyStorageContainer
nodeny  ${HOME}/.local/share/Steam
nodeny  ${HOME}/.local/share/SteamWorldDig
nodeny  ${HOME}/.local/share/SteamWorld Dig 2
nodeny  ${HOME}/.local/share/SuperHexagon
nodeny  ${HOME}/.local/share/Terraria
nodeny  ${HOME}/.local/share/vpltd
nodeny  ${HOME}/.local/share/vulkan
nodeny  ${HOME}/.mbwarband
nodeny  ${HOME}/.paradoxinteractive
nodeny  ${HOME}/.steam
nodeny  ${HOME}/.steampath
nodeny  ${HOME}/.steampid
# needed for STEAM_RUNTIME_PREFER_HOST_LIBRARIES=1 to work
nodeny  /sbin
nodeny  /usr/sbin

# Allow java (blacklisted by disable-devel.inc)
include allow-java.inc

# Allow python (blacklisted by disable-interpreters.inc)
include allow-python2.inc
include allow-python3.inc

include disable-common.inc
include disable-devel.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc

mkdir ${HOME}/.config/Epic
mkdir ${HOME}/.config/Loop_Hero
mkdir ${HOME}/.config/ModTheSpire
mkdir ${HOME}/.config/RogueLegacy
mkdir ${HOME}/.config/unity3d
mkdir ${HOME}/.killingfloor
mkdir ${HOME}/.klei
mkdir ${HOME}/.local/share/3909/PapersPlease
mkdir ${HOME}/.local/share/aspyr-media
mkdir ${HOME}/.local/share/bohemiainteractive
mkdir ${HOME}/.local/share/cdprojektred
mkdir ${HOME}/.local/share/Dredmor
mkdir ${HOME}/.local/share/FasterThanLight
mkdir ${HOME}/.local/share/feral-interactive
mkdir ${HOME}/.local/share/IntoTheBreach
mkdir ${HOME}/.local/share/Paradox Interactive
mkdir ${HOME}/.local/share/PillarsOfEternity
mkdir ${HOME}/.local/share/RogueLegacy
mkdir ${HOME}/.local/share/Steam
mkdir ${HOME}/.local/share/SteamWorldDig
mkdir ${HOME}/.local/share/SteamWorld Dig 2
mkdir ${HOME}/.local/share/SuperHexagon
mkdir ${HOME}/.local/share/Terraria
mkdir ${HOME}/.local/share/vpltd
mkdir ${HOME}/.local/share/vulkan
mkdir ${HOME}/.mbwarband
mkdir ${HOME}/.paradoxinteractive
mkdir ${HOME}/.steam
mkfile ${HOME}/.steampath
mkfile ${HOME}/.steampid
allow  ${HOME}/.config/Epic
allow  ${HOME}/.config/Loop_Hero
allow  ${HOME}/.config/ModTheSpire
allow  ${HOME}/.config/RogueLegacy
allow  ${HOME}/.config/RogueLegacyStorageContainer
allow  ${HOME}/.config/unity3d
allow  ${HOME}/.killingfloor
allow  ${HOME}/.klei
allow  ${HOME}/.local/share/3909/PapersPlease
allow  ${HOME}/.local/share/aspyr-media
allow  ${HOME}/.local/share/bohemiainteractive
allow  ${HOME}/.local/share/cdprojektred
allow  ${HOME}/.local/share/Dredmor
allow  ${HOME}/.local/share/FasterThanLight
allow  ${HOME}/.local/share/feral-interactive
allow  ${HOME}/.local/share/IntoTheBreach
allow  ${HOME}/.local/share/Paradox Interactive
allow  ${HOME}/.local/share/PillarsOfEternity
allow  ${HOME}/.local/share/RogueLegacy
allow  ${HOME}/.local/share/RogueLegacyStorageContainer
allow  ${HOME}/.local/share/Steam
allow  ${HOME}/.local/share/SteamWorldDig
allow  ${HOME}/.local/share/SteamWorld Dig 2
allow  ${HOME}/.local/share/SuperHexagon
allow  ${HOME}/.local/share/Terraria
allow  ${HOME}/.local/share/vpltd
allow  ${HOME}/.local/share/vulkan
allow  ${HOME}/.mbwarband
allow  ${HOME}/.paradoxinteractive
allow  ${HOME}/.steam
allow  ${HOME}/.steampath
allow  ${HOME}/.steampid
include whitelist-common.inc
include whitelist-var-common.inc

# NOTE: The following were intentionally left out as they are alternative
# (i.e.: unnecessary and/or legacy) paths whose existence may potentially
# clobber other paths (see #4225).  If you use any, either add the entry to
# steam.local or move the contents to a path listed above (or open an issue if
# it's missing above).
#mkdir ${HOME}/.config/RogueLegacyStorageContainer
#mkdir ${HOME}/.local/share/RogueLegacyStorageContainer

caps.drop all
#ipc-namespace
netfilter
nodvd
nogroups
nonewprivs
# If you use nVidia you might need to add 'ignore noroot' to your steam.local.
noroot
notv
nou2f
# For VR support add 'ignore novideo' to your steam.local.
novideo
protocol unix,inet,inet6,netlink
# seccomp sometimes causes issues (see #2951, #3267).
# Add 'ignore seccomp' to your steam.local if you experience this.
seccomp !ptrace
shell none
# tracelog breaks integrated browser
#tracelog

# private-bin is disabled while in testing, but is known to work with multiple games.
# Add the next line to your steam.local to enable private-bin.
#private-bin awk,basename,bash,bsdtar,bzip2,cat,chmod,cksum,cmp,comm,compress,cp,curl,cut,date,dbus-launch,dbus-send,desktop-file-edit,desktop-file-install,desktop-file-validate,dirname,echo,env,expr,file,find,getopt,grep,gtar,gzip,head,hostname,id,lbzip2,ldconfig,ldd,ln,ls,lsb_release,lsof,lspci,lz4,lzip,lzma,lzop,md5sum,mkdir,mktemp,mv,netstat,ps,pulseaudio,python*,readlink,realpath,rm,sed,sh,sha1sum,sha256sum,sha512sum,sleep,sort,steam,steamdeps,steam-native,steam-runtime,sum,tail,tar,tclsh,test,touch,tr,umask,uname,update-desktop-database,wc,wget,which,whoami,xterm,xz,zenity
# Extra programs are available which might be needed for select games.
# Add the next line to your steam.local to enable support for these programs.
#private-bin java,java-config,mono
# To view screenshots add the next line to your steam.local.
#private-bin eog,eom,gthumb,pix,viewnior,xviewer

private-dev
# private-etc breaks a small selection of games on some systems. Add 'ignore private-etc'
# to your steam.local to support those.
private-etc alsa,alternatives,asound.conf,bumblebee,ca-certificates,crypto-policies,dbus-1,drirc,fonts,group,gtk-2.0,gtk-3.0,host.conf,hostname,hosts,ld.so.cache,ld.so.conf,ld.so.conf.d,ld.so.preload,localtime,lsb-release,machine-id,mime.types,nvidia,os-release,passwd,pki,pulse,resolv.conf,services,ssl
private-tmp

# dbus-user none
# dbus-system none

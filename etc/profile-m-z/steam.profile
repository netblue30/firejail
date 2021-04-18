# Firejail profile for steam
# Description: Valve's Steam digital software delivery system
# This file is overwritten after every install/update
# Persistent local customizations
include steam.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.config/Epic
noblacklist ${HOME}/.config/Loop_Hero
noblacklist ${HOME}/.config/ModTheSpire
noblacklist ${HOME}/.config/RogueLegacy
noblacklist ${HOME}/.killingfloor
noblacklist ${HOME}/.klei
noblacklist ${HOME}/.local/share/3909/PapersPlease
noblacklist ${HOME}/.local/share/aspyr-media
noblacklist ${HOME}/.local/share/bohemiainteractive
noblacklist ${HOME}/.local/share/cdprojektred
noblacklist ${HOME}/.local/share/Dredmor
noblacklist ${HOME}/.local/share/FasterThanLight
noblacklist ${HOME}/.local/share/feral-interactive
noblacklist ${HOME}/.local/share/IntoTheBreach
noblacklist ${HOME}/.local/share/Paradox Interactive
noblacklist ${HOME}/.local/share/PillarsOfEternity
noblacklist ${HOME}/.local/share/RogueLegacy*
noblacklist ${HOME}/.local/share/Steam
noblacklist ${HOME}/.local/share/SteamWorldDig
noblacklist ${HOME}/.local/share/SteamWorld Dig 2
noblacklist ${HOME}/.local/share/SuperHexagon
noblacklist ${HOME}/.local/share/Terraria
noblacklist ${HOME}/.local/share/vpltd
noblacklist ${HOME}/.local/share/vulkan
noblacklist ${HOME}/.mbwarband
noblacklist ${HOME}/.paradoxinteractive
noblacklist ${HOME}/.steam
noblacklist ${HOME}/.steampath
noblacklist ${HOME}/.steampid
# needed for STEAM_RUNTIME_PREFER_HOST_LIBRARIES=1 to work
noblacklist /sbin
noblacklist /usr/sbin

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
mkdir ${HOME}/.local/share/RogueLegacy*
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
whitelist ${HOME}/.config/Epic
whitelist ${HOME}/.config/Loop_Hero
whitelist ${HOME}/.config/ModTheSpire
whitelist ${HOME}/.config/RogueLegacy
whitelist ${HOME}/.config/unity3d
whitelist ${HOME}/.killingfloor
whitelist ${HOME}/.klei
whitelist ${HOME}/.local/share/3909/PapersPlease
whitelist ${HOME}/.local/share/aspyr-media
whitelist ${HOME}/.local/share/bohemiainteractive
whitelist ${HOME}/.local/share/cdprojektred
whitelist ${HOME}/.local/share/Dredmor
whitelist ${HOME}/.local/share/FasterThanLight
whitelist ${HOME}/.local/share/feral-interactive
whitelist ${HOME}/.local/share/IntoTheBreach
whitelist ${HOME}/.local/share/Paradox Interactive
whitelist ${HOME}/.local/share/PillarsOfEternity
whitelist ${HOME}/.local/share/RogueLegacy*
whitelist ${HOME}/.local/share/Steam
whitelist ${HOME}/.local/share/SteamWorldDig
whitelist ${HOME}/.local/share/SteamWorld Dig 2
whitelist ${HOME}/.local/share/SuperHexagon
whitelist ${HOME}/.local/share/Terraria
whitelist ${HOME}/.local/share/vpltd
whitelist ${HOME}/.local/share/vulkan
whitelist ${HOME}/.mbwarband
whitelist ${HOME}/.paradoxinteractive
whitelist ${HOME}/.steam
whitelist ${HOME}/.steampath
whitelist ${HOME}/.steampid
include whitelist-common.inc
include whitelist-var-common.inc

caps.drop all
#ipc-namespace
netfilter
nodvd
# nVidia users may need to comment / ignore nogroups and noroot
nogroups
nonewprivs
noroot
notv
nou2f
# novideo should be commented for VR
novideo
protocol unix,inet,inet6,netlink
# seccomp sometimes causes issues (see #2951, #3267),
# comment it or add 'ignore seccomp' to steam.local if so.
seccomp !ptrace
shell none
# tracelog breaks integrated browser
#tracelog

# private-bin is disabled while in testing, but has been tested working with multiple games
#private-bin awk,basename,bash,bsdtar,bzip2,cat,chmod,cksum,cmp,comm,compress,cp,curl,cut,date,dbus-launch,dbus-send,desktop-file-edit,desktop-file-install,desktop-file-validate,dirname,echo,env,expr,file,find,getopt,grep,gtar,gzip,head,hostname,id,lbzip2,ldconfig,ldd,ln,ls,lsb_release,lsof,lspci,lz4,lzip,lzma,lzop,md5sum,mkdir,mktemp,mv,netstat,ps,pulseaudio,python*,readlink,realpath,rm,sed,sh,sha1sum,sha256sum,sha512sum,sleep,sort,steam,steamdeps,steam-native,steam-runtime,sum,tail,tar,tclsh,test,touch,tr,umask,uname,update-desktop-database,wc,wget,which,whoami,xterm,xz,zenity
# extra programs are available which might be needed for select games
#private-bin java,java-config,mono
# picture viewers are needed for viewing screenshots
#private-bin eog,eom,gthumb,pix,viewnior,xviewer

# comment the following line if you need controller support
private-dev
# private-etc breaks a small selection of games on some systems, comment to support those
private-etc alsa,alternatives,asound.conf,bumblebee,ca-certificates,crypto-policies,dbus-1,drirc,fonts,group,gtk-2.0,gtk-3.0,host.conf,hostname,hosts,ld.so.cache,ld.so.conf,ld.so.conf.d,ld.so.preload,localtime,lsb-release,machine-id,mime.types,nvidia,os-release,passwd,pki,pulse,resolv.conf,services,ssl
private-tmp

# breaks appindicator support
# dbus-user none
# dbus-system none

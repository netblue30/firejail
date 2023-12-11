# Firejail profile for steam
# Description: Valve's Steam digital software delivery system
# This file is overwritten after every install/update
# Persistent local customizations
include steam.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.config/Epic
noblacklist ${HOME}/.config/Loop_Hero
noblacklist ${HOME}/.config/MangoHud
noblacklist ${HOME}/.config/ModTheSpire
noblacklist ${HOME}/.config/RogueLegacy
noblacklist ${HOME}/.config/RogueLegacyStorageContainer
noblacklist ${HOME}/.factorio
noblacklist ${HOME}/.killingfloor
noblacklist ${HOME}/.klei
noblacklist ${HOME}/.local/share/3909/PapersPlease
noblacklist ${HOME}/.local/share/aspyr-media
noblacklist ${HOME}/.local/share/Baba_Is_You
noblacklist ${HOME}/.local/share/bohemiainteractive
noblacklist ${HOME}/.local/share/cdprojektred
noblacklist ${HOME}/.local/share/Colossal Order
noblacklist ${HOME}/.local/share/Dredmor
noblacklist ${HOME}/.local/share/FasterThanLight
noblacklist ${HOME}/.local/share/feral-interactive
noblacklist ${HOME}/.local/share/HotlineMiami
noblacklist ${HOME}/.local/share/IntoTheBreach
noblacklist ${HOME}/.local/share/Paradox Interactive
noblacklist ${HOME}/.local/share/PillarsOfEternity
noblacklist ${HOME}/.local/share/RogueLegacy
noblacklist ${HOME}/.local/share/RogueLegacyStorageContainer
noblacklist ${HOME}/.local/share/Steam
noblacklist ${HOME}/.local/share/SteamWorldDig
noblacklist ${HOME}/.local/share/SteamWorld Dig 2
noblacklist ${HOME}/.local/share/SuperHexagon
noblacklist ${HOME}/.local/share/Terraria
noblacklist ${HOME}/.local/share/vpltd
noblacklist ${HOME}/.local/share/vulkan
noblacklist ${HOME}/.mbwarband
noblacklist ${HOME}/.paradoxinteractive
noblacklist ${HOME}/.paradoxlauncher
noblacklist ${HOME}/.prey
noblacklist ${HOME}/.steam
noblacklist ${HOME}/.steampath
noblacklist ${HOME}/.steampid
noblacklist ${HOME}/Zomboid
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
include disable-programs.inc

mkdir ${HOME}/.config/Epic
mkdir ${HOME}/.config/Loop_Hero
mkdir ${HOME}/.config/MangoHud
mkdir ${HOME}/.config/ModTheSpire
mkdir ${HOME}/.config/RogueLegacy
mkdir ${HOME}/.config/unity3d
mkdir ${HOME}/.factorio
mkdir ${HOME}/.killingfloor
mkdir ${HOME}/.klei
mkdir ${HOME}/.local/share/3909/PapersPlease
mkdir ${HOME}/.local/share/aspyr-media
mkdir ${HOME}/.local/share/Baba_Is_You
mkdir ${HOME}/.local/share/bohemiainteractive
mkdir ${HOME}/.local/share/cdprojektred
mkdir ${HOME}/.local/share/Colossal Order
mkdir ${HOME}/.local/share/Dredmor
mkdir ${HOME}/.local/share/FasterThanLight
mkdir ${HOME}/.local/share/feral-interactive
mkdir ${HOME}/.local/share/HotlineMiami
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
mkdir ${HOME}/.paradoxlauncher
mkdir ${HOME}/.prey
mkdir ${HOME}/.steam
mkdir ${HOME}/Zomboid
mkfile ${HOME}/.steampath
mkfile ${HOME}/.steampid
whitelist ${HOME}/.config/Epic
whitelist ${HOME}/.config/Loop_Hero
whitelist ${HOME}/.config/MangoHud
whitelist ${HOME}/.config/ModTheSpire
whitelist ${HOME}/.config/RogueLegacy
whitelist ${HOME}/.config/RogueLegacyStorageContainer
whitelist ${HOME}/.config/unity3d
whitelist ${HOME}/.factorio
whitelist ${HOME}/.killingfloor
whitelist ${HOME}/.klei
whitelist ${HOME}/.local/share/3909/PapersPlease
whitelist ${HOME}/.local/share/aspyr-media
whitelist ${HOME}/.local/share/Baba_Is_You
whitelist ${HOME}/.local/share/bohemiainteractive
whitelist ${HOME}/.local/share/cdprojektred
whitelist ${HOME}/.local/share/Colossal Order
whitelist ${HOME}/.local/share/Dredmor
whitelist ${HOME}/.local/share/FasterThanLight
whitelist ${HOME}/.local/share/feral-interactive
whitelist ${HOME}/.local/share/HotlineMiami
whitelist ${HOME}/.local/share/IntoTheBreach
whitelist ${HOME}/.local/share/Paradox Interactive
whitelist ${HOME}/.local/share/PillarsOfEternity
whitelist ${HOME}/.local/share/RogueLegacy
whitelist ${HOME}/.local/share/RogueLegacyStorageContainer
whitelist ${HOME}/.local/share/Steam
whitelist ${HOME}/.local/share/SteamWorldDig
whitelist ${HOME}/.local/share/SteamWorld Dig 2
whitelist ${HOME}/.local/share/SuperHexagon
whitelist ${HOME}/.local/share/Terraria
whitelist ${HOME}/.local/share/vpltd
whitelist ${HOME}/.local/share/vulkan
whitelist ${HOME}/.mbwarband
whitelist ${HOME}/.paradoxinteractive
whitelist ${HOME}/.paradoxlauncher
whitelist ${HOME}/.prey
whitelist ${HOME}/.steam
whitelist ${HOME}/.steampath
whitelist ${HOME}/.steampid
whitelist ${HOME}/Zomboid
include whitelist-common.inc
include whitelist-var-common.inc

# Note: The following were intentionally left out as they are alternative
# (i.e.: unnecessary and/or legacy) paths whose existence may potentially
# clobber other paths (see #4225). If you use any, either add the entry to
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
noroot
notv
nou2f
# For VR support add 'ignore novideo' to your steam.local.
novideo
protocol unix,inet,inet6,netlink
# seccomp sometimes causes issues (see #2951, #3267).
# Add 'ignore seccomp' to your steam.local if you experience this.
# mount, name_to_handle_at, pivot_root and umount2 are used by Proton >= 5.13
# (see #4366).
seccomp !chroot,!mount,!name_to_handle_at,!pivot_root,!process_vm_readv,!ptrace,!umount2
# process_vm_readv is used by GE-Proton7-18 (see #5185).
seccomp.32 !process_vm_readv
# tracelog breaks integrated browser
#tracelog

# private-bin is disabled while in testing, but is known to work with multiple games.
# Add the next line to your steam.local to enable private-bin.
#private-bin awk,basename,bash,bsdtar,bzip2,cat,chmod,cksum,cmp,comm,compress,cp,curl,cut,date,dbus-launch,dbus-send,desktop-file-edit,desktop-file-install,desktop-file-validate,dirname,echo,env,expr,file,find,getopt,grep,gtar,gzip,head,hostname,id,lbzip2,ldconfig,ldd,ln,ls,lsb_release,lsof,lspci,lz4,lzip,lzma,lzop,md5sum,mkdir,mktemp,mv,netstat,ps,pulseaudio,python*,readlink,realpath,rm,sed,sh,sha1sum,sha256sum,sha512sum,sleep,sort,steam,steamdeps,steam-native,steam-runtime,sum,tail,tar,tclsh,test,touch,tr,umask,uname,update-desktop-database,wc,wget,wget2,which,whoami,xterm,xz,zenity
# Extra programs are available which might be needed for select games.
# Add the next line to your steam.local to enable support for these programs.
#private-bin java,java-config,mono
# To view screenshots add the next line to your steam.local.
#private-bin eog,eom,gthumb,pix,viewnior,xviewer

private-dev
# private-etc breaks a small selection of games on some systems. Add 'ignore private-etc'
# to your steam.local to support those.
private-etc @games,@tls-ca,@x11,bumblebee,dbus-1,host.conf,lsb-release,mime.types,os-release,services
private-tmp

#dbus-user none
#dbus-system none

#restrict-namespaces
